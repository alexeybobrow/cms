module Cms
  class ImageAttachmentForm < ::Cms::BaseModelForm
    model ImageAttachment

    attribute :image

    def before_save
      Rails.cache.clear
    end
  end
end
