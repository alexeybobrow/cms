module Cms
  class ContentForm < ::Cms::BaseModelForm
    model Content

    attribute :id
    attribute :body
    attribute :markup_language, default: 'markdown'
    attribute :attachments_cache

    validates :markup_language, inclusion: { in: Content.formats }

    def before_save
      if @model.page
        Cms::PropPopulator.populate @model.page, with: Cms::PropExtractor::Title, from: :body do |text, page|
          if text.present?
            page.name = text unless page.override_name?
            page.title = text unless page.override_title?
            page.breadcrumb_name = text unless page.override_breadcrumb_name?
          end
        end

        Cms::PropPopulator.populate @model.page, with: Cms::PropExtractor::Url, from: :body do |text, page|
          unless page.override_url?
            text ||= page.id
            new_url = page.parent_url.to_s + Cms::UrlHelper.normalize_url(text)
            Cms::UrlUpdate.perform(page, new_url)
          end
        end
      end
    end
  end
end
