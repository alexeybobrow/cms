class MoveDataFromDescriptionField < ActiveRecord::Migration
  def up
    res = ActiveRecord::Base.connection.execute(
      'select id, description from pages'
    )

    res.to_a.select { |page_record| page_record['description'].present? }.each do |page_record|
      page = Page.find(page_record['id'])
      unless page.meta.any? { |meta| meta['name'] == 'description' }
        page.meta << { name: 'description', content: page_record['description'] }
        page.save
      end
    end
  end

  def down
  end
end
