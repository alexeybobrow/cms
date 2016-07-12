class ChangeOverrideUrlFieldForOldPages < ActiveRecord::Migration
  def up
    execute <<-sql
      UPDATE pages
      SET override_url = TRUE
    sql
  end

  def down
  end
end
