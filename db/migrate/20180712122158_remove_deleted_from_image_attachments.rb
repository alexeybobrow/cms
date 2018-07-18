class RemoveDeletedFromImageAttachments < ActiveRecord::Migration
  def up
    remove_column :image_attachments, :deleted
  end

  def down
    add_column :image_attachments, :deleted, :boolean, default: false, nil: false
  end
end
