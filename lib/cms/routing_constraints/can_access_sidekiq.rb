module Cms
  module RoutingConstraints
    class CanAccessSidekiq
      def matches?(request)
        request.remote_ip == ENV['CMS_SIDEKIQ_DEBUG_FROM']
      end
    end
  end
end
