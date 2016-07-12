module Cms::PropExtractor
  class Title < ::Cms::PropExtractor::Base
    def self.analyser
      Cms::ContentAnalyser::Title
    end
  end
end
