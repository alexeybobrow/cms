module Cms
  module HtmlFilter
    def meta_pipeline(options={})
      create_pipeline [Filters::LiquidParser], options
    end

    def simple_pipeline(options={})
      create_pipeline [
        Filters::TemplateVariablesFilter,
        Filters::LiquidParser,
        Filters::SyntaxHighlight,
        HTML::Pipeline::AbsoluteSourceFilter
      ], options
    end

    def markdown_pipeline(options={})
      create_pipeline [
        Filters::TemplateVariablesFilter,
        Filters::SetLayout,
        Filters::MarkdownFilter,
        HTML::Pipeline::AbsoluteSourceFilter,
        HTML::Pipeline::HttpsFilter,
        HTML::Pipeline::AutolinkFilter,
        Filters::LiquidParser,
        Filters::SyntaxHighlight
      ], options
    end

    def create_pipeline(filters, options)
      skip_filters = options[:skip] || []
      HTML::Pipeline.new(filters - skip_filters, context)
    end

    def context
      {
        view: self,
        template_variables: template_variables,
        controller: controller,
        path: request.try(:fullpath),
        base_url: Cms.host,
        image_base_url: root_url(host: Cms.host) # for liquid fragment tag
      }
    end
  end
end
