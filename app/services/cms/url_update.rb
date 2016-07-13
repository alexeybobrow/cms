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
      # wow. so unfunctional. much imperativ

      if self.primary_url.nil?
        page.build_primary_url
      end

      if self.primary_url.name == name
        return
      end

      self.primary_url.name = uniq_name_from(name)

      if need_alias?
        page.urls.build(name: primary_url.name_was)
      end

      primary_url.save
    end

    private

    def need_alias?
      page.published? && primary_url.persisted? && primary_url.name_changed?
    end

    def uniq_name_from(name, index=0)
      new_name =  index.zero? ? name : "#{name}-#{index}"

      if Url.where(name: new_name).any?
        uniq_name_from(name, index + 1)
      else
        new_name
      end
    end
  end
end
