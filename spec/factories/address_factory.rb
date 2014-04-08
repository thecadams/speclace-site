FactoryGirl.define do
  factory :address do
    first_name 'First Name'
    last_name 'Last Name'
    street_address_1 'Street Address 1'
    city 'City'
    state 'State'
    postcode 'Postcode'
    country 'Country'
    email 'email@example.com'
  end
end
