module Cms::PropExtractor
  class Url < Base
    def self.analyser
      Cms::ContentAnalyser::Url
    end
  end
end
