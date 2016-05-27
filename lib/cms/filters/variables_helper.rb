module Cms
  module Filters
    module VariablesHelper
      VARIABLES_PATTERN = /\{\s*([\w]+\s*=\s*[\w]+)\s*}/

      def extract_variables!
        @variables = @text
          .scan(VARIABLES_PATTERN)
          .flatten
          .map{|var_string| var_string.split(/\s*=\s*/) }
          .to_h

        fill_context!

        @text.gsub!(VARIABLES_PATTERN, '')
      end

      private

      def fill_context!
        if context[:template_variables]
          @variables.each do |name, value|
            context[:template_variables][name] = value
          end
        end
      end
    end
  end
end
