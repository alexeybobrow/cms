class ImageAttachment < ActiveRecord::Base
  mount_uploader :image, Cms::PageImageUploader

  validates_presence_of :image

  def image_url(options = {})
    options = image.processable?(image) ? options : {};
    super(options).gsub(Rails.root.to_s, '')
  end

  def image_alt
    alt || image_identifier.sub(/\..*/, '').humanize
  end

  def file_path(name, extension)
    path = self.image.path.gsub(self.image_identifier, "#{name}.#{extension}")
    File.exists?(path) ? path : nil
  end
end
