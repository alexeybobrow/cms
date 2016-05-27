module Cms
  module Filters
    autoload :FixInvalidParagraphs, 'cms/filters/fix_invalid_paragraphs'
    autoload :LiquidParser, 'cms/filters/liquid_parser'
    autoload :SyntaxHighlight, 'cms/filters/syntax_highlight'
    autoload :MarkdownFilter, 'cms/filters/markdown_filter'
    autoload :SetLayout, 'cms/filters/set_layout'
    autoload :VariablesHelper, 'cms/filters/variables_helper'
    autoload :TemplateVariablesFilter, 'cms/filters/template_variables_filter'
  end
end
