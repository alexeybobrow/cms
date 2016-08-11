module Cms
  module RoutingConstraints
    autoload :SetLocaleConstraint, 'cms/routing_constraints/set_locale_constraint'
    autoload :CanAccessSidekiq, 'cms/routing_constraints/can_access_sidekiq'
  end
end
