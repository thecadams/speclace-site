class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :order_id
      t.boolean :ok
      t.text :response_data
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
