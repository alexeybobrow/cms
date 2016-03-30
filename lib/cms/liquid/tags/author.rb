module Cms
  module Liquid
    module Tags
      class Author < Base
        def render(context)
          "<a href='/blog/author/#{@markup.strip.downcase.gsub(/\s/, '-')}'>#{@markup}</a>"
        end
      end
    end
  end
end

::Liquid::Template.register_tag('author', Cms::Liquid::Tags::Author)
