module Tags
  class Heading < Cms::Liquid::Tags::Base
    def render(context)
      <<-html
        <h2 class="landing-heading">
          #{unquote(@markup.strip)}
        </h2>
      html
    end
  end
end

::Liquid::Template.register_tag('heading', Tags::Heading)
