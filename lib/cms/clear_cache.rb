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
  class ClearCache
    include Capybara::DSL

    def run
      Page.with_published_state.map(&:url).each do |url|
        visit url
      end
    end
  end
end
