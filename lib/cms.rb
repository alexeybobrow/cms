require "cms/version"
require "commonmarker"

module Cms
  autoload :RoutingConstraints, 'cms/routing_constraints'
  autoload :Filters, 'cms/filters'
  autoload :UrlHelper, 'cms/url_helper'
  autoload :LocaleRedirector, 'cms/locale_redirector'
  autoload :SafeDelete, 'cms/safe_delete'
  autoload :Liquid, 'cms/liquid'

  mattr_accessor(:host) { "PLEASE, SET ME!" }

  def self.setup
    yield(self)
  end
end

require "cms/engine"
