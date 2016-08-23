module Cms::PropExtractor
  class AbsoluteUrl < Base
    def self.analyser
      Cms::ContentAnalyser::AbsoluteUrl
    end
  end
end
