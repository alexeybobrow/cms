module Cms::PropExtractor
  class Image < Base
    def self.analyser
      Cms::ContentAnalyser::Image
    end
  end
end
