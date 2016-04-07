module Tags
  class Tagline < Liquid::Block
    def render(context)
      <<-html
        <div class="landing-tagline">
          #{super(context)}
        </div>
      html
    end
  end
end

::Liquid::Template.register_tag('tagline', Tags::Tagline)
