class AddStockLevelToProducts < ActiveRecord::Migration
  def change
    add_column :products, :stock_level, :integer, null: false, default: 0
  end
end
