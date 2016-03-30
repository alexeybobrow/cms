module Cms
  module Liquid
    module Tags
      class BaseBlock < ::Liquid::Block
        include AttributesUtils

        def initialize(tag_name, markup, tokens)
          extract_attributes!(markup)
          super
        end
      end
    end
  end
end
