require 'babosa'

module Cms::ContentAnalyser
  class Url < ::Cms::ContentAnalyser::Base
    def run
      if title = title_analyser(content).run
        '/'+title.to_slug.normalize(transliterations: :russian).to_s
      end
    end

    def title_analyser(content)
      Cms::ContentAnalyser::Title.new(content)
    end
  end
end
