module Tags
  class Layout < Cms::Liquid::Tags::BaseBlock
    def render(context)
      @context = context
      <<-html
        <div class="simple-layout">
          <div class="inner" style="#{styles}">
            <div class="#{classes} content">
              #{super(context)}
            </div>
          </div>
        </div>
      html
    end

    private

    def styles
      [].tap do |s|
        s << "max-width: #{width}" if width
      end.join(';')
    end

    def classes
      [].tap do |s|
        if @attributes['fancy_headings']
          s << 'fancy-headings'
        end
      end.join(' ')
    end

    def width
      @attributes['width'] || @context.registers['layout_width']
    end
  end
end

::Liquid::Template.register_tag('layout', Tags::Layout)
