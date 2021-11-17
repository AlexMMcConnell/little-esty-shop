require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it {should belong_to :item}
    it {should belong_to :invoice}
  end

  before(:each) do
    @merchant = create(:merchant)
    @item = create(:item, merchant: @merchant)
    @invoice = create(:invoice)
    @bulk_discount = create(:bulk_discount, merchant: @merchant, quantity_threshold: 4, percentage_discount: 50)
    @bulk_discount2 = create(:bulk_discount, merchant: @merchant, quantity_threshold: 6, percentage_discount: 75)
    @invoice_item1 = create(:invoice_item, invoice: @invoice, item: @item, unit_price: 10, quantity: 10)
    @invoice_item2 = create(:invoice_item, invoice: @invoice, item: @item, unit_price: 20, quantity: 10)
  end

  it 'returns the best applicable discount for the item' do
    expect(@invoice_item1.bulk_discount).to eq(@bulk_discount2)
  end
end
