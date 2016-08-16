class RenameOgFieldToMeta < ActiveRecord::Migration
  def change
    rename_column :pages, :meta, :raw_meta
    rename_column :pages, :og, :meta
  end
end
