module Cms
  module RoutingConstraints
    class PrimaryUrlConstraint
      def matches?(request)
        url_from(request).try(:primary?)
      end

      private

      def name_from(request)
        request.env["action_dispatch.request.path_parameters"][:page]
      end

      def url_from(request)
        Url.where(name: '/'+name_from(request)).first
      end
    end
  end
end
