module Tags
  class HeroUnit < Liquid::Block
    include Cms::Liquid::Tags::AttributesUtils

    class HeroTitle < Cms::Liquid::Tags::Base
      def render(context)
        <<-html
          <h1 class="hero-unit--title">
            #{unquote(@markup.strip)}
          </h1>
        html
      end
    end

    class HeroDescription < Liquid::Block
      def render(context)
        <<-html
          <div class="hero-unit--description">
            #{super(context)}
          </div>
        html
      end
    end

    class HeroButton < Cms::Liquid::Tags::Base
      def render(context)
        <<-html
          <a href="#{unquote(@attributes['url'])}" class="hero-unit--button plain-button">
            #{unquote(text)}
          </a>
        html
      end
    end

    class HeroImage < Cms::Liquid::Tags::Base
      def render(context)
        src = unquote(@markup.strip)
        <<-html
          <div class="hero-unit--image">
            <img src="#{src}" alt="#{src}" class="hero-unit--img" />
          </div>
        html
      end
    end

    def initialize(tag_name, markup, tokens)
      extract_attributes!(markup)
      super
    end

    def render(context)
      styles = []
      styles << "background-color: #{@attributes['color']}" if @attributes['color']

      <<-html
        <div class="hero-unit" style="#{styles.join('; ')}">
          <div class="hero-unit--content">
            #{super(context)}
          </div>
        </div>
      html
    end
  end
end

::Liquid::Template.register_tag('herounit', Tags::HeroUnit)
::Liquid::Template.register_tag('herotitle', Tags::HeroUnit::HeroTitle)
::Liquid::Template.register_tag('herodescription', Tags::HeroUnit::HeroDescription)
::Liquid::Template.register_tag('herobutton', Tags::HeroUnit::HeroButton)
::Liquid::Template.register_tag('heroimage', Tags::HeroUnit::HeroImage)
