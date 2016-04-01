class ImageAttachment < ActiveRecord::Base
  mount_uploader :image, Cms::PageImageUploader

  validates_presence_of :image

  def image_url(options = {})
    options = image.processable?(image) ? options : {};
    super(options).gsub(Rails.root.to_s, '')
  end

  def file_path(name, extension)
    path = self.image.path.gsub(self.image_identifier, "#{name}.#{extension}")
    File.exists?(path) ? path : nil
  end

  def remove
    self.update_attribute(:deleted, true)
  end

  def restore
    self.update_attribute(:deleted, false)
  end

  def available?
    !self.deleted?
  end

  def to_json_params
    { pic_path:    self.image_url(:thumb),
      data_url:    self.image_url,
      name:        self.image_identifier,
      id:          self.id,
      created_at:  self.created_at.strftime("%d %b %H:%M") }
  end

end
