require 'rails_helper'

# FactoryBot.find_definitions

RSpec.describe 'show page' do
  before(:each) do
    @merchant = create(:merchant)
    @customer = create(:customer)

    @invoice = create(:invoice, customer: @customer)

    @item = create(:item, merchant: @merchant)
    @item2 = create(:item, merchant: @merchant)

    @inv_item = create(:invoice_item, invoice: @invoice, item: @item, quantity: 20, unit_price: 435)
    @inv_item2 = create(:invoice_item, invoice: @invoice, item: @item, quantity: 10, unit_price: 131)
    @inv_item3 = create(:invoice_item, invoice: @invoice, item: @item2, quantity: 5, unit_price: 50)

    @discount = create(:bulk_discount, merchant: @merchant, percentage_discount: 25, quantity_threshold: 15)
    @discount2 = create(:bulk_discount, merchant: @merchant, percentage_discount: 50, quantity_threshold: 9)

    visit "/merchants/#{@merchant.id}/invoices/#{@invoice.id}"
  end

  it 'shows invoice id and status' do
    expect(page).to have_content(@invoice.id)
    expect(page).to have_content(@invoice.status)
  end

  it 'shows created_at information as day of week, month day #, year' do
    expect(page).to have_content(DateTime.now.new_offset(0).strftime("%A, %B %d, %Y"))
  end

  it 'shows the first and last name of the customer related to the invoice' do
    expect(page).to have_content(@customer.first_name)
    expect(page).to have_content(@customer.last_name)
  end

  it 'shows the item name, quantity ordered, price, invoice item status' do
    expect(page).to have_content(@invoice.items.first.name)
    expect(page).to have_content(@invoice.items.first.invoice_item_quantity(@invoice))
    expect(page).to have_content("$" + (@inv_item.unit_price/100.0).round(2).to_s )
    expect(page).to have_content(@invoice.items.first.invoice_item_status(@invoice))
  end

  it 'shows invoice total revenue' do
    price = @inv_item.quantity * @inv_item.unit_price + @inv_item2.quantity * @inv_item2.unit_price + 250
    string_price = ((price) / 100.0).round(2).to_s
    expect(page).to have_content("$" + string_price)
  end

  it 'shows dropdown for changing status' do
    expect(page).to have_content('packaged pending shipped')
    expect(page).to have_content('Change status')

    within("#item-#{@invoice.items.last.id}") do
      expect(page).to_not have_content("Status: #{@invoice.status}")
      select('shipped', from: 'invoice_item_status')
      expect(page).to have_select('invoice_item_status', selected: 'shipped')
      expect(page).to have_content('shipped')
    end
  end

  it 'shows discounted revenue' do
    visit "/merchants/#{@merchant.id}/invoices/#{@invoice.id}"
    price = @inv_item.quantity * @inv_item.unit_price + @inv_item2.quantity * @inv_item2.unit_price + 500
    string_price = (price / 200.0).round(2).to_s
    expect(page).to have_content("$" + string_price)
  end

  it 'has a link to the bulk discount page for a given discount' do
    click_link "#{@discount2.percentage_discount}%"

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@discount2.id}")
  end
end
