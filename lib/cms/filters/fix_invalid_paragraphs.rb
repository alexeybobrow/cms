module Cms
  module Filters
    class FixInvalidParagraphs < ::HTML::Pipeline::TextFilter
      def call
        recursive_gsub(/<p>(\s*<(?:div|section).*>.*<\/(?:div|section)>)(?:<\/p>)?/m, '\1', @text)
      end

      private

      def recursive_gsub(search, replace, value)
        if value.match(search)
          recursive_gsub(search, replace, value.gsub(search, replace))
        else
          value
        end
      end
    end
  end
end
