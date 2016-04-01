module Cms
  class PageImageUploader < ImageUploader
    version :thumb, :if => :processable? do
      process resize_to_fill: [126,126]
    end

    version :preview, :if => :processable? do
      process resize_to_limit: [280,280]
    end

    def processable?(picture)
      return false if content_type.include?('svg')
      content_type.include?('image')
    end
  end
end
