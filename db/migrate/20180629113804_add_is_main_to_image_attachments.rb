class AddIsMainToImageAttachments < ActiveRecord::Migration
  def up
    add_column :image_attachments, :is_main, :boolean, default: false

    execute <<-sql
      UPDATE image_attachments
      SET is_main = TRUE
      WHERE id IN (
        SELECT DISTINCT CASE WHEN attachments_cache LIKE ''
          THEN 0
          ELSE split_part(attachments_cache, ',', 2)::INT END
        FROM contents
      );
    sql
  end

  def down
    remove_column :image_attachments, :is_main
  end
end
