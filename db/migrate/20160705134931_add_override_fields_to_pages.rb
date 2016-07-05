class AddOverrideFieldsToPages < ActiveRecord::Migration
  def change
    add_column :pages, :override_name, :boolean, default: true
    add_column :pages, :override_title, :boolean, default: true
    add_column :pages, :override_breadcrumb_name, :boolean, default: true
  end
end
