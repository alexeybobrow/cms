class AddOverrideUrlFieldToPages < ActiveRecord::Migration
  def change
    add_column :pages, :override_url, :boolean, default: false
  end
end
