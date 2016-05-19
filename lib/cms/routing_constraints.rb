module Cms
  module RoutingConstraints
    autoload :SetLocaleConstraint, 'cms/routing_constraints/set_locale_constraint'
    autoload :PrimaryUrlConstraint, 'cms/routing_constraints/primary_url_constraint'
    autoload :UrlAliasesDispatcher, 'cms/routing_constraints/url_aliases_dispatcher'
  end
end
