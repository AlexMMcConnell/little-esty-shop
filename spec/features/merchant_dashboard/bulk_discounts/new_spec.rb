require 'rails_helper'

RSpec.describe 'bulk discount new page' do
  before(:each) do
    @merchant = create(:merchant)
    visit "/merchants/#{@merchant.id}/bulk_discounts/new"
  end

  it 'can create a new discount' do
    fill_in 'Quantity threshold', with: 20
    fill_in 'Percentage discount', with: 25
    click_button "Save"

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")

    expect(page).to have_content("Percentage Discount: 25%, Quantity Threshold: 20")
  end
end
