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

        @text.gsub!(VARIABLES_PATTERN, '')
      end
    end
  end
end
