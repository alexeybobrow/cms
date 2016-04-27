module Cms
  module Filters
    class SetLayout < ::HTML::Pipeline::TextFilter
      include VariablesHelper

      CONTENT_PATTERN = /\{\s*content\s*}/

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

      def layout_name
        @variables['layout'] || 'default_layout'
      end

      def layout
        @layout ||= ::Fragment.where(slug: layout_name).first.try(:body)
      end
    end
  end
end
