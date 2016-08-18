class RemoveRawMetaField < ActiveRecord::Migration
  def change
    remove_column :pages, :raw_meta
  end

  def down
    add_column :pages, :raw_meta, :text
  end
end
