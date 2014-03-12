class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :blurb_html
      t.text :details_html
      t.text :how_to_wear_it_html
      t.decimal :price_in_aud, null: false
      t.decimal :price_in_usd, null: false
      t.boolean :new_arrival, null: false, default: false
      t.boolean :most_popular, null: false, default: false
      t.boolean :gift_idea, null: false, default: false
      t.integer :priority, null: false, default: 100
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
