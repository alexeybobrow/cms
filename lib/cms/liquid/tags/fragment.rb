module Cms
  module Liquid
    module Tags
      class Fragment < Base
        def render(context)
          @context = context
          view.render_fragment(unquote(@markup.strip))
        end
      end
    end
  end
end

::Liquid::Template.register_tag('fragment', Cms::Liquid::Tags::Fragment)
