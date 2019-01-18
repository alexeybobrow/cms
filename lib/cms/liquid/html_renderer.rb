module Cms
  module Liquid
    class HtmlRenderer < CommonMarker::HtmlRenderer
      def initialize(options: :UNSAFE)
        super
      end

      def paragraph(node)
        if is_liquid_tag?(node.to_html)
          out(:children)
        else
          super
        end
      end

      private

      # Example:
      #   "<p>{% layout width: 600px %}</p>"
      def is_liquid_tag?(markup)
        /<p>\s*{%.*%}\s*<\/p>/ === markup
      end
    end
  end
end
