module Cms
  class ClearCache
    def self.perform
      new.perform
    end

    def perform
      Rails.cache.clear
      Page.with_published_state.map(&:url).each do |url|
        Cms::RestoreCacheWorker.perform_async(url)
      end
    end
  end
end
