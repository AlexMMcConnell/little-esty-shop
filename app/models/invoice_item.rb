class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  delegate :merchant, to: :item
  delegate :customer, to: :invoice

  enum status: { "packaged" => 0,
                 "pending" => 1,
                 "shipped" => 2
               }

  scope :invoice_item_revenue, -> { sum("unit_price * quantity") }

  def self.invoice_item_price(invoice)
    find_by(invoice: invoice).unit_price
  end

  def self.invoice_item_quantity(invoice)
    find_by(invoice: invoice).quantity
  end

  def self.invoice_item_status(invoice)
    find_by(invoice: invoice).status
  end

  def self.discounted_revenue
    disc_revenue = discounts_applied.sum do |discount|
      discount.revenue
    end

    discount_invoice_ids = discounts_applied.map do |discount|
      discount.id
    end

    no_discounts_applied = non_discount_revenue(discount_invoice_ids)

    no_disc_revenue = no_discounts_applied.sum do |no_discount|
      no_discount.revenue
    end

    sum = disc_revenue + no_disc_revenue
    binding.pry
    sum
  end

  def self.non_discount_revenue(inv_item_ids)
    joins(item: [{merchant: :bulk_discounts}])
    .where('bulk_discounts.quantity_threshold <= (:min)', min: BulkDiscount.select('MIN(quantity_threshold)'))
    .where("quantity < bulk_discounts.quantity_threshold")
    .select("invoice_items.id as id")
    .select("(invoice_items.unit_price * invoice_items.quantity) AS revenue")
  end

  def self.discounts_applied
    joins(item: [{merchant: :bulk_discounts}])
    .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
    .where('bulk_discounts.percentage_discount >= (:max)', max: BulkDiscount.select('MAX(percentage_discount)'))
    .order("bulk_discounts.percentage_discount DESC")
    .select("invoice_items.id as id")
    .select("bulk_discounts.id AS bulk_discount_id")
    .select("(invoice_items.unit_price * invoice_items.quantity * bulk_discounts.percentage_discount / 100) AS revenue")
  end

  def inv_item_sum(invoice, new_sum)
    sum = invoice[0] * invoice[1]
    if sum = new_sum
      sum
    else
      new_sum
    end
  end
end
