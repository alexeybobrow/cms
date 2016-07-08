module Cms::PagePropPopulator
  class Title < ::Cms::PagePropPopulator::Base
    def self.analyser
      Cms::ContentAnalyser::Title
    end
  end
end
