module Cms
  module RoutingConstraints
    class UrlAliasesDispatcher
      def initialize(router)
        @router = router
      end

      def call(env)
        url = Url.where(name: '/'+url_from(env)).first!
        redirect_to(url.page.url, env)
      end

      private

      def url_from(env)
        env["action_dispatch.request.path_parameters"][:page]
      end

      def redirect_to(url, env)
        @router.redirect{|p, req| url }.call(env)
      end
    end
  end
end
