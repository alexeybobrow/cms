module Cms
  class PublicationPolicy
    def initialize(page)
      @page = page
    end

    def publish?
      @page.url.present?
    end
  end
end
