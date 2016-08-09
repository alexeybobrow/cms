module Cms
  class ContentForm < ::Cms::BaseModelForm
    model Content

    attribute :id
    attribute :body
    attribute :markup_language, default: 'markdown'
    attribute :attachments_cache

    validates :markup_language, inclusion: { in: Content.formats }

    def before_save
      Cms::PropPopulator::ForPage.populate(model.page)
      Cms::PropPopulator::ForUrl.populate(model.page)

      Cms::ClearCache.perform
    end
  end
end
