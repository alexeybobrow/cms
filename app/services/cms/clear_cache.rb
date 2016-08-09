module Cms
  class ClearCache
    def self.perform
      new.perform
    end

    def perform
      begin
        Rails.cache.clear
      rescue Errno::ENOTEMPTY
        # Likely to happen in test environment
        # with FileStore cache

        puts "Cache dir is not empty"
      end

      Page.with_published_state.map(&:url).each do |url|
        Cms::RestoreCacheWorker.perform_async(url)
      end
    end
  end
end
