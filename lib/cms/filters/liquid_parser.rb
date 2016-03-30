module Cms
  module Filters
    class LiquidParser < ::HTML::Pipeline::TextFilter
      def call
        ::Liquid::Template.parse(@text).render(context, registers: LiquidVariable.as_hash)
      end
    end
  end
end
