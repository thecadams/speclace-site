class MakeProductRangeRequired < ActiveRecord::Migration
  def change
    change_column :products, :product_range_id, :integer, null: false
  end
end
