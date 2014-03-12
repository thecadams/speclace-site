class AddDeletedAtToContactRequest < ActiveRecord::Migration
  def change
    add_column :contact_requests, :deleted_at, :datetime
  end
end
