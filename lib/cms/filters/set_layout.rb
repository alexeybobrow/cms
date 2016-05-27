module Cms
  module Filters
    class SetLayout < ::HTML::Pipeline::TextFilter
      include VariablesHelper

      CONTENT_PATTERN = /\{\s*content\s*}/
      DEFAULT_LAYOUT = 'default_layout'

      class << self
        def path_prefix_pattern
          @path_prefix_pattern ||= compute_pattern
        end

        def compute_pattern
          available_locales = I18n.available_locales.map{|l| Regexp.escape(l) + "\/"}
          /\A\/(?:#{available_locales.join('|')})?([\w\-]*)/
        end
      end

      def call
        extract_variables!
        wrapped_with_layout.html_safe
      end

      private

      def layout_pipeline
        HTML::Pipeline.new [
          Filters::TemplateVariablesFilter
        ], self.context
      end

      def wrapped_with_layout
        if layout
          content = layout.body.gsub(CONTENT_PATTERN, @text)
          layout_pipeline.call(content)[:output].to_s
        else
          @text
        end
      end

      def layout
        @layout ||=

        if layout_from_var
          find_layout(layout_from_var)
        else
          find_layout(layout_from_path) ||
          find_layout(DEFAULT_LAYOUT)
        end
      end

      def find_layout(name)
        ::Fragment.where(slug: name).first
      end

      def layout_from_var
        @variables['layout'] || layout_from_context
      end

      def layout_from_context
        if template_variables = self.context[:template_variables]
          template_variables[:layout]
        end
      end

      def layout_from_path
        if path = self.context[:path].presence
          path.match(SetLayout.path_prefix_pattern).captures.first
        end
      end
    end
  end
end
