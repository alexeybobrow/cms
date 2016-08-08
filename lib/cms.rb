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

module Cms
  autoload :RoutingConstraints, 'cms/routing_constraints'
  autoload :Filters, 'cms/filters'
  autoload :UrlHelper, 'cms/url_helper'
  autoload :LocaleRedirector, 'cms/locale_redirector'
  autoload :SafeDelete, 'cms/safe_delete'
  autoload :Liquid, 'cms/liquid'
  autoload :ArrayAccessors, 'cms/array_accessors'
  autoload :FolderStructure, 'cms/folder_structure'
  autoload :PropExtractor, 'cms/prop_extractor'
  autoload :ContentAnalyser, 'cms/content_analyser'
  autoload :ClearCache, 'cms/clear_cache'

  mattr_accessor(:host) { "PLEASE, SET ME!" }

  def self.setup
    yield(self)
  end
end

require "cms/engine"
