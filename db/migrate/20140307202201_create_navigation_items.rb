class CreateNavigationItems < ActiveRecord::Migration
  def change
    create_table :navigation_items do |t|
      t.string :menu_name, default: 'main'
      t.integer :parent_id
      t.integer :order_within_parent, default: 1
      t.string :href
      t.string :text
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :navigation_items, :deleted_at
  end
end
