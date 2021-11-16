require 'rails_helper'

RSpec.describe 'bulk discount show page' do
  before(:each) do
    @merchant = create(:merchant)
    @bulk_discount = create(:bulk_discount, merchant: @merchant)

    visit "/merchants/#{@merchant.id}/bulk_discounts/#{@bulk_discount.id}"
  end

  it 'shows information for the given discount' do
    expect(page).to have_content(@bulk_discount.percentage_discount)
    expect(page).to have_content(@bulk_discount.quantity_threshold)
  end

  it 'has a link to edit bulk discounts' do
    click_link "Edit This Bulk Discount"

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@bulk_discount.id}/edit")
  end

  it 'shows the next three holidays and their dates' do
    within('div#holidays') do
      expect(page).to have_content("Thanksgiving Day, coming up on 2021-11-25")
      expect(page).to have_content("Christmas Day, coming up on 2021-12-24")
      expect(page).to have_content("New Year's Day, coming up on 2021-12-31")
    end
  end
end
