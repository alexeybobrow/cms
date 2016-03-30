module Cms
  module Liquid
    module Tags
      class LinkTo < Base
        def render(context)
          @context = context
          view.link_to(text.html_safe, @attributes['path'], @attributes.except('path'))
        end
      end
    end
  end
end

::Liquid::Template.register_tag('link_to', Cms::Liquid::Tags::LinkTo)
