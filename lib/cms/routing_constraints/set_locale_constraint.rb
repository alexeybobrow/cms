module Cms
  module RoutingConstraints
    class SetLocaleConstraint
      def matches?(request)
        request.env['localized'] = true
        true
      end
    end
  end
end
