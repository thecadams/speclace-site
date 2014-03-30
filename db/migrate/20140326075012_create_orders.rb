class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :session_id
      t.integer :delivery_address_id
      t.integer :billing_address_id
      t.text :comments
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
