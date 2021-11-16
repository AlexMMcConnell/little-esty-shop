require 'rails_helper'

RSpec.describe 'bulk discount edit page' do
  before(:each) do
    @merchant = create(:merchant)
    @bulk_discount = create(:bulk_discount, merchant: @merchant, quantity_threshold: 15, percentage_discount: 10)
    visit "/merchants/#{@merchant.id}/bulk_discounts/#{@bulk_discount.id}/edit"
  end

  it 'has the discounts current attributes pre-populated in the form' do
    expect(page).to have_field('percent', with: 10)
    expect(page).to have_field('quantity', with: 15)
  end

  it 'allows you to change the information and submit it with any/all updated information you filled in saved' do
    fill_in "percent", with: "20"
    fill_in "quantity", with: "25"

    click_button "Save"
    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@bulk_discount.id}")
    expect(page).to have_content("Percentage Discount: 20")
    expect(page).to have_content("Quantity Threshold: 25")
  end
end
