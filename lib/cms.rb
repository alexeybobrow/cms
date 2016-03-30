require "cms/version"

module Cms
  autoload :RoutingConstraints, 'cms/routing_constraints'
  autoload :Filters, 'cms/filters'
  autoload :UrlHelper, 'cms/url_helper'
  autoload :LocaleRedirector, 'cms/locale_redirector'
  autoload :SafeDelete, 'cms/safe_delete'
  autoload :Liquid, 'cms/liquid'
end

require "cms/engine"
