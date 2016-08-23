module Cms
  class PropPopulator
    def self.populate(model, prop, options={})
      if prop.is_a?(Hash)
        options = prop
      end

      skip_populate = (options[:unless] && model.send(options[:unless])) ||
        (options[:if] && !model.send(options[:if]))

      unless skip_populate
        populator = options[:with]
        content = model.send(options[:from])

        if block_given?
          yield populator.analyse(content), model
        else
          populator.populate(model, prop, content)
        end
      end
    end

    class ForPage
      def self.populate(model)
        PropPopulator.populate model, with: Cms::PropExtractor::Title, from: :body do |text, page|
          if text.present?
            page.name = text unless page.override_name?
            page.title = text unless page.override_title?
            page.breadcrumb_name = text unless page.override_breadcrumb_name?
          end
        end
      end
    end

    class ForUrl
      def self.populate(model)
        PropPopulator.populate model, with: Cms::PropExtractor::Url, from: :body, unless: :override_url? do |text, page|
          text ||= page.id
          new_url = page.parent_url.to_s + Cms::UrlHelper.normalize_url(text)
          Cms::UrlUpdate.perform(page, new_url)
        end
      end
    end

    class ForPageMeta
      attr_reader :model

      cattr_accessor :defaults do
        []
      end

      class << self
        def configure
          yield self
        end

        def populate(model)
          new(model)
        end
      end

      def initialize(model)
        @model = model

        populate_with_defaults
        populate_og_title
        populate_og_url
        populate_og_type
        populate_og_image
      end

      private

      def populate_with_defaults
        return if model.override_meta_tags?

        ForPageMeta.defaults.each do |default_meta|
          default_meta.each do |(meta_id, meta_value)|
            model.set_meta(meta_id, meta_value)
          end
        end
      end

      def populate_with_meta(page, meta_id, content)
        if content.present?
          page.set_meta(meta_id, { 'content' => content })
        end
      end

      def populate_og_title
        PropPopulator.populate model, with: Cms::PropExtractor::Title, from: :body, unless: :override_meta_tags? do |text, page|
          populate_with_meta(page, {'property' => 'og:title'}, text)
        end
      end

      def populate_og_url
        PropPopulator.populate model, with: Cms::PropExtractor::AbsoluteUrl, from: :body, unless: :override_meta_tags? do |text, page|
          populate_with_meta(page, {'property' => 'og:url'}, text)
        end
      end

      def populate_og_type
        PropPopulator.populate model, with: Cms::PropExtractor::PageType, from: :url, unless: :override_meta_tags? do |text, page|
          populate_with_meta(page, {'property' => 'og:type'}, text)
        end
      end

      def populate_og_image
        PropPopulator.populate model, with: Cms::PropExtractor::Image, from: :body, unless: :override_meta_tags? do |text, page|
          populate_with_meta(page, {'property' => 'og:image'}, text)
        end
      end
    end
  end
end
