class ChangeOverrideFieldsValuesForOldPages < ActiveRecord::Migration
  def up
    execute <<-sql
      UPDATE pages
      SET override_name = TRUE,
          override_title = TRUE,
          override_breadcrumb_name = TRUE
    sql
  end

  def down
  end
end
