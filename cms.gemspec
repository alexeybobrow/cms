# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cms/version'

Gem::Specification.new do |spec|
  spec.name          = "cms"
  spec.version       = Cms::VERSION
  spec.authors       = ["dak", "akd", "ib"]
  spec.email         = ["dak@anahoret.com", "akd@anahoret.com", "ib@anahoret.com"]

  spec.summary       = %q{CMS engine}
  spec.description   = %q{RoR plugin to host manageable static pages}
  spec.homepage      = "https://anadea.info"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://rubygems.anahoret.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "actionpack-action_caching", ">= 1.1.0", "< 1.2"
  spec.add_dependency "commonmarker", "~> 0.20.1"
  spec.add_dependency "palmister", ">= 0.0.2"
  spec.add_dependency "liquid", ">= 3.0.6", "< 4"
  spec.add_dependency "workflow", "~> 1.3.0"
  spec.add_dependency "paper_trail", "~> 4.2.0"
  spec.add_dependency "default_value_for", "~> 3.1.0"
  spec.add_dependency "active_attr", "~> 0.11.0"
  spec.add_dependency "html-pipeline", "~> 2.8.0"
  spec.add_dependency "nokogiri", "<= 1.8.5"
  spec.add_dependency "rinku", "~> 2.0.4"
  spec.add_dependency "truncate_html", "~> 0.9.3"
  spec.add_dependency "kaminari", "~> 1.1.1"
  spec.add_dependency "carrierwave", "~> 1.2.2"
  spec.add_dependency "mini_magick", "~> 4.8.0"
  spec.add_dependency "babosa", "~> 1.0.2"

  spec.add_dependency "capybara", "~> 3.32.2"
  spec.add_dependency "poltergeist", "~> 1.18.1"
  spec.add_dependency "sidekiq", "~> 5.2.7"

  spec.add_dependency "rouge", "~> 3.30"
  spec.add_dependency "github-linguist", "~> 6.2.0"
  spec.add_dependency "charlock_holmes", "= 0.7.6"
  spec.add_dependency "rugged", "~> 0.27.1"

  spec.add_dependency "image_optim", "~> 0.26.4"
  spec.add_dependency "image_optim_pack", "~> 0.5.3"


  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
