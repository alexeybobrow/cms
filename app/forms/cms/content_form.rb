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
        Cms::PropPopulator.populate @model.page, with: Cms::PropExtractor::Title, from: :body do |text, model|
          if text.present?
            model.name = text unless model.override_name?
            model.title = text unless model.override_title?
            model.breadcrumb_name = text unless model.override_breadcrumb_name?
          end
        end

        Cms::PropPopulator.populate @model.page, with: Cms::PropExtractor::Url, from: :body do |text, model|
          if text.present?
            Cms::UrlUpdate.perform(model, text) unless model.override_url?
          end
        end
      end
    end
  end
end
