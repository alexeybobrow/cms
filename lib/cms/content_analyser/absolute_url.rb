module Cms::ContentAnalyser
  class AbsoluteUrl < ::Cms::ContentAnalyser::Url
    def run
      if url = super
        Cms.host + url
      end
    end
  end
end
