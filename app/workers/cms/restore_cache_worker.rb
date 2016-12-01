require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, window_size: [1600, 768], js_errors: false)
end

module Cms
  class RestoreCacheWorker
    include Sidekiq::Worker
    include Capybara::DSL

    sidekiq_options queue: :restore_cache, retry: 3

    def perform(url)
      initalize_driver!

      visit url
    end

    private

    def initalize_driver!
      Capybara.run_server = false
      Capybara.current_driver = :poltergeist
      Capybara.app_host = Cms.host

      page.driver.basic_authorize(
        ENV['APP_AUTH_USER'], ENV['APP_AUTH_PASSWORD']
      ) if ENV['APP_AUTH_USER'] && ENV['APP_AUTH_PASSWORD']

      page.driver.browser.url_blacklist = [
        'https://s.ytimg.com',
        'https://mc.yandex.ru',
        'https://www.youtube.com'
      ]
    end
  end
end
