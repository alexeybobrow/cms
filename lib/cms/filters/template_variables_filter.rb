module Cms
  module Filters
    class TemplateVariablesFilter < ::HTML::Pipeline::TextFilter
      include VariablesHelper

      def call
        extract_variables!
        @text
      end
    end
  end
end
