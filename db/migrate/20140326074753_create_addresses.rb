class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :company
      t.string :street_address_1, null: false
      t.string :street_address_2
      t.string :city, null: false
      t.string :postcode, null: false
      t.string :state, null: false
      t.string :country, null: false
      t.string :email, null: false
      t.string :phone
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
