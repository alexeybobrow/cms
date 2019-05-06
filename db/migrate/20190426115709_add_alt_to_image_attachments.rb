class AddAltToImageAttachments < ActiveRecord::Migration
  def change
    add_column :image_attachments, :alt, :string
  end
end
