module Cms
  module Filters
    autoload :FixInvalidParagraphs, 'cms/filters/fix_invalid_paragraphs'
    autoload :LiquidParser, 'cms/filters/liquid_parser'
    autoload :SyntaxHighlight, 'cms/filters/syntax_highlight'
    autoload :MarkdownFilter, 'cms/filters/markdown_filter'
  end
end
