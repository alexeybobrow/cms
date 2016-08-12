require 'capybara'

module Cms
  class StopBrowserWorker
    include Sidekiq::Worker

    sidekiq_options queue: :restore_cache, retry: 3

    def perform
      session_pool = Capybara.instance_variable_get("@session_pool")
      session_pool.each do | key, value |
        value.driver.quit
      end
      session_pool.clear
    end
  end
end

