module Cms
  module Liquid
    module Tags
      class Snippet < Base
        def initialize(tag_name, markup, tokens)
          super

          if match = markup.match(/'([^']+)'/)
            @name = match.captures.first
          else
            @name = markup.strip
          end
        end

        def render(context)
          @context = context
          render_haml(template_content, @attributes)
        end

        private

        def template_content
          ::Liquid::Template.file_system.read_template_file(@name, {})
        end
      end
    end
  end
end

::Liquid::Template.register_tag('snippet', Cms::Liquid::Tags::Snippet)
