module Tags
  class Columns < Liquid::Block
    class ColumnHeading < Cms::Liquid::Tags::Base
      def render(context)
        <<-html
          <h3 class="columns--heading">
            #{unquote(@markup.strip)}
          </h3>
        html
      end
    end

    class Column < Liquid::Block
      def render(context)
        <<-html
          <div class="columns--column">
            #{super(context)}
          </div>
        html
      end
    end

    def render(context)
      <<-html
        <div class="columns">
          #{super(context)}
        </div>
      html
    end
  end
end

::Liquid::Template.register_tag('columns', Tags::Columns)
::Liquid::Template.register_tag('column', Tags::Columns::Column)
::Liquid::Template.register_tag('colheading', Tags::Columns::ColumnHeading)
