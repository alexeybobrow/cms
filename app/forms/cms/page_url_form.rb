module Cms
  class PageUrlForm < ::Cms::BaseModelForm
    model Page

    attr_writer :url

    validates :url, presence: true,
                    format: { with: %r{\A/[/a-z0-9_-]*\z}, allow_blank: true }
    validate :url_uniqueness

    def url
      @url || model.url
    end

    def clean_attributes
      unless model.primary_url
        model.build_primary_url
      end

      self.url = Cms::UrlHelper.normalize_url(url)
      model.primary_url.name = self.url
    end

    private

    def url_uniqueness
      errors.add(:url, :taken) if Url.where(name: self.url.downcase).any?
    end
  end
end
