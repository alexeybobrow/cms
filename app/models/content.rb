class Content < ActiveRecord::Base
  has_one :_page_as_content, class_name: 'Page', foreign_key: 'content_id', autosave: true
  has_one :_page_as_annotation, class_name: 'Page', foreign_key: 'annotation_id', autosave: true

  after_save :touch_page

  def self.formats; %w(html markdown text); end

  has_paper_trail only: [:body, :markup_language]

  def text?
    markup_language == 'text'
  end

  def page
    _page_as_content || _page_as_annotation
  end

  def attachments
    self.attachments_cache.split(',').map{|i| ImageAttachment.where(id: i).first}.compact
  end

  def add_attachments_to_cache(attachment_ids)
    new_hash = (self.attachments_cache.split(',') + attachment_ids.map(&:to_s)).uniq
    self.update_attribute(:attachments_cache, new_hash.join(','))
  end

  def delete_attachment_from_cache(attachment_id)
    self.update_attribute(:attachments_cache, self.attachments_cache.sub(",#{attachment_id}", ''))
  end

  def main_image
    self.attachments && self.attachments.first
  end

  def restore_to(version)
    version.reify.save!
  end

  private

  def touch_page
    page.try(:touch)
  end
end
