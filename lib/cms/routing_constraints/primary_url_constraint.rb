module Cms
  module RoutingConstraints
    class PrimaryUrlConstraint
      def matches?(request)
        url_from(request).try(:primary?)
      end

      private

      def url_from(request)
        url_param = request.env["action_dispatch.request.path_parameters"][:page]
        Url.where(name: '/'+url_param).first
      end
    end
  end
end
