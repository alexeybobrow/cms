require 'babosa'

module Cms::PagePropPopulator
  class Url < ::Cms::PagePropPopulator::Base
    def self.analyser
      Cms::ContentAnalyser::Url
    end
  end
end
