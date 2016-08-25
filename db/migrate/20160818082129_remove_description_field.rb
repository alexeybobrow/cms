class RemoveDescriptionField < ActiveRecord::Migration
  def change
    remove_column :pages, :description
  end

  def down
    add_column :pages, :description, :text
  end
end
