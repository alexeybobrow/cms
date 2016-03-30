module Cms
  module Liquid
    module Tags
      class Base < ::Liquid::Tag
        include HamlUtils
        include AttributesUtils

        def initialize(tag_name, markup, tokens)
          extract_attributes!(markup)
          super
        end

        def text
          @markup.match(/'([^']+)'/)[1]
        end
      end
    end
  end
end
