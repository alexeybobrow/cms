module Cms
  module Liquid
    autoload :HtmlRenderer, 'cms/liquid/html_renderer'
    autoload :MultipleFileSystem, 'cms/liquid/multiple_file_system'
    autoload :Tags, 'cms/liquid/tags'
    autoload :TemplateVariables, 'cms/liquid/template_variables'
    autoload :HtmlAttributesParser, 'cms/liquid/html_attributes_parser'

    def self.load!(options)
      ::Liquid::Template.file_system = Liquid::MultipleFileSystem.new options[:template_paths]
      load_tags options[:tag_paths]
    end

    def self.load_tags(paths)
      Dir.glob(paths).each { |f| load(f) }
    end
    private_class_method :load_tags
  end
end
