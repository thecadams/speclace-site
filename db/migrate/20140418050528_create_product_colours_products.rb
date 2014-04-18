class CreateProductColoursProducts < ActiveRecord::Migration
  def change
    create_table :product_colours_products do |t|
      t.integer :product_id
      t.integer :product_colour_id
      t.timestamps
    end
  end
end
