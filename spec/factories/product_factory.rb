FactoryGirl.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }

    price_in_aud 1
    image_1 { $image }
    image_2 { $image }
    image_3 { $image }
    product_range { create(:product_range) }
    stock_level 1
  end
end
