module Cms
  module Liquid
    module Tags
      module AttributesUtils
        def extract_attributes!(markup)
          @attributes = {}

          markup.scan(::Liquid::TagAttributes) do |key, value|
            @attributes[key] = unquote(value)
          end
        end

        def unquote(text)
          text.strip.gsub(/^[\" \']|[\" \']?$/, '')
        end
      end
    end
  end
end
