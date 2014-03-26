class RemovePriceInUsdFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :price_in_usd, :decimal
  end
end
