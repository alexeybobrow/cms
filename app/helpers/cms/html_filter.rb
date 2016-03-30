module Cms
  module HtmlFilter

    def simple_pipeline
      HTML::Pipeline.new [
        Filters::LiquidParser,
        Filters::SyntaxHighlight,
        HTML::Pipeline::AbsoluteSourceFilter
      ], context
    end

    def markdown_pipeline
      HTML::Pipeline.new [
        Filters::MarkdownFilter,
        HTML::Pipeline::AbsoluteSourceFilter,
        HTML::Pipeline::HttpsFilter,
        HTML::Pipeline::AutolinkFilter,
        Filters::LiquidParser,
        Filters::SyntaxHighlight
      ], context
    end

    def context
      {
        view: self,
        controller: controller,
        base_url: Settings.host,
        image_base_url: root_url(host: Settings.host) # for liquid fragment tag
      }
    end

  end
end
