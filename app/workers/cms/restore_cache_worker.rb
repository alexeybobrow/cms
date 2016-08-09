require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

Capybara.run_server = false
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, window_size: [1600, 768])
end
Capybara.current_driver = :poltergeist
Capybara.app_host = 'http://localhost:3000'

module Cms
  class RestoreCacheWorker
    include Sidekiq::Worker
    include Capybara::DSL

    sidekiq_options queue: :restore_cache

    def perform(url)
      visit url
    end
  end
end
