module Cms
  class UrlUpdate
    attr_reader :name
    attr_reader :page

    delegate :primary_url, to: :page

    def self.perform(page, name)
      new(page, name).perform
    end

    def initialize(page, name)
      @page = page
      @name = name
    end

    def perform
      page.build_primary_url if self.primary_url.nil?
      self.primary_url.name = name
      if need_alias?
        page.urls.build(name: primary_url.name_was)
      end
      primary_url.save
    end

    private

    def need_alias?
      page.published? && primary_url.persisted? && primary_url.name_changed?
    end
  end
end
