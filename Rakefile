require "bundler/gem_tasks"
require "bundler/setup"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task default: :spec

APP_RAKEFILE = File.expand_path("../spec/rails_app/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'
