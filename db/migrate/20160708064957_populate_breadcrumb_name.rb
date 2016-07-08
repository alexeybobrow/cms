class PopulateBreadcrumbName < ActiveRecord::Migration
  def up
    execute <<-sql
      UPDATE pages
      SET breadcrumb_name = title
      WHERE breadcrumb_name = ''
    sql
  end

  def down
  end
end
