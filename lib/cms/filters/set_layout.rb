module Cms
  module Filters
    class SetLayout < ::HTML::Pipeline::TextFilter
      include VariablesHelper

      CONTENT_PATTERN = /\{\s*content\s*}/
      PATH_PREFIX_PATTERN = /\A\/([\w\-]*)/
      DEFAULT_LAYOUT = 'default_layout'

      def call
        extract_variables!
        wrapped_with_layout.html_safe
      end

      private

      def wrapped_with_layout
        if layout
          layout.gsub(CONTENT_PATTERN, @text)
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
        ::Fragment.where(slug: name).first.try(:body)
      end

      def layout_from_var
        @variables['layout']
      end

      def layout_from_path
        if path = self.context[:path].presence
          path.match(PATH_PREFIX_PATTERN).captures.first
        end
      end
    end
  end
end
