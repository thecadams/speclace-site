class AddImagesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :image_1_id, :integer
    add_column :products, :image_2_id, :integer
    add_column :products, :image_3_id, :integer
    add_column :products, :image_4_id, :integer
  end
end
