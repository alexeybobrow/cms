module Cms::PropExtractor
  class AbsoluteUrl < Url
    def self.analyse(content)
      if url = super
        Cms.host + url
      end
    end
  end
end
