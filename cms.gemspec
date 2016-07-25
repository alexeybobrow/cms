# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cms/version'

Gem::Specification.new do |spec|
  spec.name          = "cms"
  spec.version       = Cms::VERSION
  spec.authors       = ["dak", "akd"]
  spec.email         = ["dak@anahoret.com", "akd@anahoret.com"]

  spec.summary       = %q{CMS engine}
  spec.description   = %q{RoR plugin to host manageable static pages}
  spec.homepage      = "http://anadea.info"

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

  spec.add_dependency "actionpack-action_caching", ">= 1.1.0"
  spec.add_dependency "commonmarker", ">= 0.7.0"
  spec.add_dependency "palmister", ">= 0.0.2"
  spec.add_dependency "liquid", ">= 3.0.6"
  spec.add_dependency "workflow"
  spec.add_dependency "paper_trail", ">= 4.0.0"
  spec.add_dependency "default_value_for", ">= 3.0.1"
  spec.add_dependency "active_attr", ">= 0.8.5"
  spec.add_dependency "html-pipeline", ">= 2.2.2"
  spec.add_dependency "rinku", ">= 1.7.3"
  spec.add_dependency "truncate_html", ">= 0.9.3"
  spec.add_dependency "kaminari", ">= 0.16.3"
  spec.add_dependency "carrierwave", ">= 0.10.0"
  spec.add_dependency "mini_magick", ">= 4.3.6"
  spec.add_dependency "babosa", ">= 1.0.2"

  spec.add_dependency "pygments.rb"
  spec.add_dependency "github-linguist", ">= 4.7.0"


  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
