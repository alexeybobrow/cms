module Cms
  class ImageAttachmentForm < ::Cms::BaseModelForm
    model ImageAttachment

    attribute :image

    def before_save
      Cms::ClearCache.perform
    end
  end
end
