module Tags
  class Landing < Liquid::Block
    def render(context)
      <<-html
        <div class="landing-page">
          #{super(context)}
        </div>
      html
    end
  end
end

::Liquid::Template.register_tag('landing', Tags::Landing)
