class Content < ActiveRecord::Base
  def self.formats; %w(html markdown); end

  has_paper_trail only: [:body, :markup_language]

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
end
