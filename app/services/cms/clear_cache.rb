module Cms
  class ClearCache
    def self.perform
      new.perform
    end

    def perform
      if Rails.application.config.action_controller.perform_caching
        Rails.cache.clear

        Page.with_published_state.map(&:url).each do |url|
          Cms::RestoreCacheWorker.perform_async(url)
        end

        Cms::StopBrowserWorker.perform_async
      end
    end
  end
end
