require File.expand_path('../boot', __FILE__)

require "rails/all"
Bundler.require(*Rails.groups)

require "cms"

module RailsApp
  class Application < Rails::Application
    config.action_mailer.delivery_method = :test
    config.action_mailer.default_url_options = { host: 'lvh.me:3000' }

    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.test_framework  false
      g.assets          false
      g.helper          false
      g.skip_routes     true
    end

    require File.expand_path(File.join(File.dirname(__FILE__), '..', 'app', 'lib', 'auth', 'base'))
  end
end
