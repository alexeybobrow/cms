class AddOverrideMetaTagsFieldToPages < ActiveRecord::Migration
  def change
    add_column :pages, :override_meta_tags, :boolean, default: false
  end
end
