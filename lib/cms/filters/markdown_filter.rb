module Cms
  module Filters
    class MarkdownFilter < ::HTML::Pipeline::TextFilter
      def call
        doc = CommonMarker.render_doc(@text)
        Cms::Liquid::HtmlRenderer.new.render(doc)
      end
    end
  end
end
