require 'rails_helper'

RSpec.describe 'bulk discount index page' do
  before(:each) do
    @merchant = create(:merchant)

    @discounts = create_list(:bulk_discount, 3, merchant: @merchant, quantity_threshold: 60, percentage_discount: 40)

    visit "/merchants/#{@merchant.id}/bulk_discounts"
  end

  it 'shows all bulk discount information for given merchant and no other discounts' do
    @discounts.each do |discount|
      expect(page).to have_content(discount.percentage_discount)
      expect(page).to have_content(discount.quantity_threshold)
    end

    merchant2 = create(:merchant)
    discounts2 = create_list(:bulk_discount, 3, merchant: merchant2, quantity_threshold: 70, percentage_discount: 50)

    discounts2.each do |discount|
      expect(page).to_not have_content("Quantity Threshold: #{discount.quantity_threshold}")
      expect(page).to_not have_content("Percentage Discount: #{discount.percentage_discount}%")
    end
  end

  it 'has a link to each discount show page' do
    @discounts.each do |discount|
      visit "/merchants/#{@merchant.id}/bulk_discounts"
      click_link("View Discount ##{discount.id}")
      expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{discount.id}")
    end
  end

  it 'has a link to create a new discount' do
    click_link("Create a New Discount")

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/new")
  end

  it 'has a button to destroy discounts' do
    discount1 = create(:bulk_discount, merchant: @merchant, quantity_threshold: 10, percentage_discount: 20)
    visit "/merchants/#{@merchant.id}/bulk_discounts"

    click_button("Delete Bulk Discount ##{discount1.id}")

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")

    expect(page).to_not have_content("Quantity Threshold: #{discount1.quantity_threshold}")
    expect(page).to_not have_content("Percentage Discount: #{discount1.percentage_discount}%")
  end
end
