class FixPageUpdatedAt < ActiveRecord::Migration
  def up
    update <<-SQL
      UPDATE pages
      SET updated_at = GREATEST(p.updated_at, c.updated_at, a.updated_at)
      FROM pages p
      LEFT JOIN contents c ON c.id = p.content_id
      LEFT JOIN contents a ON a.id = p.annotation_id
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
