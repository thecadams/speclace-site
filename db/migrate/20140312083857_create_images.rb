class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.belongs_to :product
      t.string :url, null: false
      t.string :alt
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
