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
        PropPopulator.populate model, with: Cms::PropExtractor::Url, from: :body do |text, page|
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
