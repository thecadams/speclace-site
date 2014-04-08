class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :order_id, null: false
      t.boolean :complete, null: false, default: false
      t.string :payment_id
      t.text :payment_object
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
