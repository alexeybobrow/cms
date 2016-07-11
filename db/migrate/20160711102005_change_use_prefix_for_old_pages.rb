class ChangeUsePrefixForOldPages < ActiveRecord::Migration
  def up
    execute <<-sql
      UPDATE urls
      SET use_prefix = FALSE
    sql
  end

  def down
  end
end
