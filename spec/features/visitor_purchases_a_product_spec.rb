require 'spec_helper'

feature 'Visitor purchases a product' do
  before do
    FactoryGirl.create(:product, name: 'A Speclace')
  end

  scenario 'Choosing from all products', js: true do
    visit '/products'
    first(:button, 'Add to Cart').click
    click_button 'Checkout Securely'
    fill_in 'order[delivery_address][first_name]', with: 'first'
    fill_in 'order[delivery_address][last_name]', with: 'last'
    fill_in 'order[delivery_address][street_address_1]', with: 'street'
    fill_in 'order[delivery_address][city]', with: 'city'
    fill_in 'order[delivery_address][postcode]', with: '3000'
    select 'Australia', from: 'order_delivery_address_country', match: :first
    wait_for_ajax
    select 'Victoria', from: 'order_delivery_address_state'
    fill_in 'order[delivery_address][email]', with: 'user@example.com'
    check 'order[same_addresses]'
    click_button 'Confirm Order'

    expect(page).to have_content '1 x'
    expect(page).to have_content 'A Speclace'
    expect(page).to have_content '$1.00'
    click_button 'Submit Order'

    expect(current_url).to start_with 'https://www.sandbox.paypal.com/'

    expect(page).to have_content 'A Speclace'
    expect(page).to have_content '$1.00'
  end
end