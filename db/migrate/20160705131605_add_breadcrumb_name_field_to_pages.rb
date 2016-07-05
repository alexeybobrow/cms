class AddBreadcrumbNameFieldToPages < ActiveRecord::Migration
  def change
    add_column :pages, :breadcrumb_name, :string, default: ''
  end
end
