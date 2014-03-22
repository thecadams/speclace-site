class RemoveImageUrlAndAddAttachment < ActiveRecord::Migration
  def change
    remove_column :images, :url, :string, null: false
    add_attachment :images, :image
  end
end
