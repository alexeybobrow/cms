module Cms::PropExtractor
  class PageType < Base
    def self.analyser
      Class.new(::Cms::ContentAnalyser::Base) do
        def run
          return unless content
          content.starts_with?('/blog') ? 'article' : 'website'
        end
      end
    end
  end
end
