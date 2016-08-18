class MoveDataFromRawMeta < ActiveRecord::Migration
  def up
    res = ActiveRecord::Base.connection.execute(
      'select id, raw_meta from pages'
    )

    res.to_a.select { |meta_record| meta_record['raw_meta'] }.each do |meta_record|
      meta_record['raw_meta'].scan(/(<.*?\/>)/).each do |meta_string|
        meta_string.each do |meta|
          page = Page.find(meta_record['id'])
          page.meta << Hash[meta.scan(/(\w*)="(.*?)"/)]
          page.save
        end
      end
    end
  end

  def down
  end
end
