module Cms
  class FragmentForm < ::Cms::BaseModelForm
    model Fragment

    attribute :slug
    attribute :content_attributes

    validates :slug, presence: true,
                     format: { with: %r{\A[A-Za-z0-9_\/-]*\z} },
                     uniqueness: true

    def content
      @content ||= ContentForm.new(self.content_attributes, self.model.content || self.model.build_content)
    end

    def clean_attributes
      self.content_attributes = self.content.try(:attributes)
    end

    def valid?
      content_is_valid = self.content.valid?
      super && content_is_valid
    end

    def before_save
      Rails.cache.clear
    end
  end
end
