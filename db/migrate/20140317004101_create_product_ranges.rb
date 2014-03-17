class CreateProductRanges < ActiveRecord::Migration
  def change
    create_table :product_ranges do |t|
      t.string :name, null: false
    end
  end
end
