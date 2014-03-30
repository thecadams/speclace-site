class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :order_id, null: false
      t.boolean :complete, null: false, default: false
      t.string :token
      t.string :payer_id
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
