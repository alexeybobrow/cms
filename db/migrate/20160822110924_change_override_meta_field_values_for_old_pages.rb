class ChangeOverrideMetaFieldValuesForOldPages < ActiveRecord::Migration
  def up
    execute <<-sql
      UPDATE pages
      SET override_meta_tags = TRUE
    sql
  end

  def down
  end
end
