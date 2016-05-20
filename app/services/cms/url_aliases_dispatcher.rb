module Cms
  class UrlAliasesDispatcher
    attr_accessor :url

    def initialize(path)
      self.url = model(Cms::UrlHelper.normalize_url(path))
    end

    def dispatch
      case
      when url.nil?
        then yield :not_found
      when url.primary?
        then yield :primary, url
      else
        yield :alias, url
      end
    end

    private

    def model(path)
      Url.where(name: path).first
    end
  end
end
