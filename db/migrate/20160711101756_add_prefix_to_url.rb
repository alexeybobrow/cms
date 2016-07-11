class AddPrefixToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :prefix, :string, default: ''
    add_column :urls, :use_prefix, :boolean, default: true
  end
end
