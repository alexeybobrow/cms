module Cms
  module Liquid
    module Tags
      module HamlUtils
        def view
          @context.environments.first[:view]
        end

        def render_haml(content, *args)
          Haml::Engine.new(content).render(view, *args)
        end
      end
    end
  end
end
