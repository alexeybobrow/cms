class AddParentUrlToPages < ActiveRecord::Migration
  def change
    add_column :pages, :parent_url, :string
  end
end
