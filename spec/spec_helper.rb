require 'simplecov'
SimpleCov.start 'rails'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'rails_app/config/environment'
require 'rspec/rails'
require 'capybara-screenshot/rspec'

Rails.logger.level = 4

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
load("#{File.dirname(__FILE__)}/factories.rb")


RSpec.configure do |config|
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to this feature
  config.infer_spec_type_from_file_location!

  # If you need more of the backtrace for any of [these] deprecations to
  # identify where to make the necessary changes, you can configure
  # `config.raise_errors_for_deprecations!`, and it will turn the
  # deprecation warnings into errors, giving you the full backtrace.
  config.raise_errors_for_deprecations!

  Capybara.javascript_driver = :webkit
  Capybara.default_max_wait_time = 3

  config.include Integration::AuthHelpers
  config.include Integration::FixtureHelpers
  config.include Integration::AttachmentHelpers
  config.include Integration::MetaTagsHelpers
  config.include FactoryGirl::Syntax::Methods

  if config.files_to_run.one?
    config.formatter = 'documentation'
  end

  config.order = :random
  Kernel.srand config.seed
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
