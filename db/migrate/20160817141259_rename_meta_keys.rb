class RenameMetaKeys < ActiveRecord::Migration
  def change
    Page.all.each do |page|
      if page.meta
        page.meta = page.meta.map { |m| { 'property' => m['name'], 'content' => m['value'] } }
        page.save
      end
    end
  end
end
