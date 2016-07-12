module Cms::PropExtractor
  class Title < Base
    def self.analyser
      Cms::ContentAnalyser::Title
    end
  end
end
