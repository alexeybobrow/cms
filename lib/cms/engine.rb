module Cms
  class Engine < ::Rails::Engine
    isolate_namespace Cms

    initializer "cms.liquid" do |app|
      config.autoload_paths += %W(
        #{app.root}/app/liquid/lib
        #{app.root}/app/liquid/tags
      )

      Liquid.load! template_paths: %W(
        #{app.root}/app/liquid/snippets
        #{config.root}/app/liquid/snippets
      ), tag_paths: %W(
        #{app.root}/app/liquid/tags/**/*.rb
        #{config.root}/lib/cms/liquid/tags/**/*.rb
      )
    end

    initializer "cms.assets" do |app|
      # config.assets.paths << "#{config.root}/app/assets/stylesheets"
      # config.assets.paths << "#{root}/app/assets/stylesheets)"
    end
  end
end
