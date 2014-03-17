class AddProductRangeToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :product_range, index: true
  end
end
