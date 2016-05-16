module Cms
  class PageUrlForm < ::Cms::BaseModelForm
    model Page

    attr_accessor :primary_id
    attr_reader :url_alias

    validates :url, presence: true, format: { with: %r{\A/[/a-z0-9_-]*\z} }
    validate :primary_url_uniqueness
    validate :url_alias_uniqueness

    def after_initialize
      model.build_primary_url unless model.primary_url
    end

    def url
      @url || model.url
    end

    def url=(value)
      @url = Cms::UrlHelper.normalize_url(value)
    end

    def url_alias=(value)
      if value.present?
        @url_alias = Cms::UrlHelper.normalize_url(value)
      end
    end

    def before_save
      model.switch_primary_url(primary_id)
      model.update_primary_url(self.url)

      if url_alias.present?
        model.urls.build(name: self.url_alias)
      end
    end

    private

    def primary_url_uniqueness
      if model.primary_url.name != url && Url.where(name: url).any?
        errors.add(:url, :taken)
      end
    end

    def url_alias_uniqueness
      if url_alias.present? && Url.where(name: url_alias).any?
        errors.add(:url_alias, :taken)
      end
    end
  end
end
