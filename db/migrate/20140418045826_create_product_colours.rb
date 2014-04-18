class CreateProductColours < ActiveRecord::Migration
  def change
    create_table :product_colours do |t|
      t.string :name, null: false
    end
  end
end
