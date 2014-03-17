class CreateProductBadges < ActiveRecord::Migration
  def change
    create_table :product_badges do |t|
      t.string :name
      t.string :css_class
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
