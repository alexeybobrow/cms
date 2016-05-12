module Cms
  class PageUrlForm < ::Cms::BaseModelForm
    model Page

    attr_writer :url
    attr_accessor :primary_id

    validates :url, presence: true,
                    format: { with: %r{\A/[/a-z0-9_-]*\z}, allow_blank: true }
    validate :primary_url_uniqueness

    def url
      @url || model.url
    end

    def clean_attributes
      self.url = Cms::UrlHelper.normalize_url(url)
      model.set_primary_url(primary_id)
      primary_url.name = self.url
    end

    private

    def primary_url
      @primary_url ||= (model.primary_url || model.build_primary_url)
    end

    def primary_url_uniqueness
      if primary_url.name_changed? && Url.where(name: primary_url.name).any?
        errors.add(:url, :taken)
      end
    end
  end
end
