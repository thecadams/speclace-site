class AddProductBadgeToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :product_badge, index: true
  end
end
