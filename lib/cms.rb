require "cms/version"
require "commonmarker"
require "liquid"
require "palmister"
require "workflow"
require "paper_trail"
require "default_value_for"
require "active_attr"
require "html/pipeline"
require "linguist"
require "pygments"
require "kaminari"
require "carrierwave"
require "sidekiq"

module Cms
  autoload :RoutingConstraints, 'cms/routing_constraints'
  autoload :SidekiqMiddleware, 'cms/sidekiq_middleware'
  autoload :Filters, 'cms/filters'
  autoload :UrlHelper, 'cms/url_helper'
  autoload :LocaleRedirector, 'cms/locale_redirector'
  autoload :SafeDelete, 'cms/safe_delete'
  autoload :Liquid, 'cms/liquid'
  autoload :ArrayAccessors, 'cms/array_accessors'
  autoload :FolderStructure, 'cms/folder_structure'
  autoload :PropExtractor, 'cms/prop_extractor'
  autoload :ContentAnalyser, 'cms/content_analyser'

  mattr_accessor(:host) { "PLEASE, SET ME!" }
  mattr_accessor(:prevent_cache_urls) { [] }

  def self.setup
    yield(self)
  end

  def self.prevent_cache_regexp
    Regexp.union(prevent_cache_urls)
  end
end

require "cms/engine"
