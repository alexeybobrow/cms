module Cms
  class PageUrlForm < ::Cms::BaseModelForm
    model Page

    attribute :url, default: '/'

    validates :url,  presence: true,
                     format: { with: %r{\A/[/a-z0-9_-]*\z}, allow_blank: true },
                     uniqueness: true

    def before_save
      if @model.new_record?
        @model.content = Content.new
        @model.annotation = Content.new
      end
    end

    def clean_attributes
      self.url = Cms::UrlHelper.normalize_url(url)
    end
  end
end
