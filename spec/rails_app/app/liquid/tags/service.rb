module Tags
  class Service < Liquid::Block
    include Cms::Liquid::Tags::AttributesUtils

    def self.wrap_with_link(url)
      if url
        "<a class=\"service-link\" href=\"#{url}\">#{yield}</a>"
      else
        yield
      end
    end

    class Icon < Cms::Liquid::Tags::Base
      def render(context)
        image_path = @markup.strip

        Tags::Service.wrap_with_link(context['url']) do
          "<img src=\"#{image_path}\" class=\"service-icon\" />"
        end
      end
    end

    class Describe < Liquid::Block
      def render(context)
        service_title = @markup.strip

        <<-html
          <div class="content">
            <h2>#{Tags::Service.wrap_with_link(context['url']) { service_title }}</h2>
            <p>
              #{super(context)}
            </p>
          </div>
        html
      end
    end

    def initialize(tag_name, markup, tokens)
      extract_attributes!(markup)
      @service_name = markup.match(/^[\w-]*/)[0]
      super
    end

    def render(context)
      style = @attributes['color'] ? "style=\"background-color: #{@attributes['color']}\"" : ""
      context['url'] = @attributes['url']

      <<-html
        <div class="service-item-container">
          <div class="service-item #{@service_name}" #{style}>
            #{super(context)}
          </div>
        </div>
      html
    end
  end
end

::Liquid::Template.register_tag('service', Tags::Service)
::Liquid::Template.register_tag('icon', Tags::Service::Icon)
::Liquid::Template.register_tag('describe', Tags::Service::Describe)
