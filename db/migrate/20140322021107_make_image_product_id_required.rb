class MakeImageProductIdRequired < ActiveRecord::Migration
  def change
    change_column :images, :product_id, :integer, null: false
  end
end
