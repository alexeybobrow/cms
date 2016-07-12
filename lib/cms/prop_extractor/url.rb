require 'babosa'

module Cms::PropExtractor
  class Url < ::Cms::PropExtractor::Base
    def self.analyser
      Cms::ContentAnalyser::Url
    end
  end
end
