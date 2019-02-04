module Cms
  module Liquid
    class HtmlRenderer < CommonMarker::HtmlRenderer
      def initialize(options: :UNSAFE)
        super
        @attrs = ''
      end

      def header(node)
        block do
          out('<h', node.header_level, "#{sourcepos(node)}#{' ' << @attrs unless @attrs.empty?}>", :children,
              '</h', node.header_level, '>')
        end
        @attrs = ''
      end

      def link(node)
        unless node.next.nil?
          if is_html_attr?(node.next.to_html)
            @attrs = html_attr_to_s!(node.next.to_html)
            if /_blank/ === @attrs
              if /nofollow/ === @attrs
                @attrs = @attrs.gsub(/rel="nofollow"/, 'rel="noopener noreferrer nofollow"')
              else
                @attrs << ' rel="noopener noreferrer"'
              end
            end
            node.next.string_content = ''
          end
        end

        out('<a href="', node.url.nil? ? '' : escape_href(node.url), '"')
        if node.title && !node.title.empty?
          out(' title="', escape_html(node.title), '"')
        end
        out("#{' ' << @attrs unless @attrs.empty?}>", :children, '</a>')
        @attrs = ''
      end

      def paragraph(node)
        if is_liquid_tag?(node.to_html)
          out(:children)
        elsif is_html_attr?(node.to_html)

          # store @attrs for header and return :header node
          if node.first_child.next.nil?
            @attrs = html_attr_to_s!(node.to_html)
            node.first_child.delete
            return out(:children)

          # store @attrs for paragraph and return :paragraph node
          elsif node.first_child.type === :text && is_html_attr?(node.first_child.string_content)
            @attrs = html_attr_to_s!(node.first_child.string_content)
            node.first_child.delete

          # store @attrs for link and return :link node
          elsif node.first_child.type === :link
            if node.last_child.type === :text && is_html_attr?(node.last_child.string_content)
              return out(:children)
            end
          end


          if @in_tight && node.parent.type != :blockquote
            out(:children)
          else
            block do
              container("<p#{sourcepos(node)}#{' ' << @attrs unless @attrs.empty?}>", '</p>') do
                out(:children)
                if node.parent.type == :footnote_definition && node.next.nil?
                  out(" ")
                  out_footnote_backref
                end
              end
            end
            @attrs = ''
          end
        else
          super
        end
      end

      private

      # Example:
      #   "<p>{% layout width: 600px %}</p>"
      #
      #   Or
      #   "<p>{% herounit color: red %}
      #   {% herotitle Ruby on Rails %}
      #   {% heroimage hero.png %}
      #   {% herodescription %}
      #     Anadea has state-of-the art expertise in Ruby on Rails development.
      #   {% endherodescription %}
      #   {% herobutton 'Contact Us', url: /contact-us %}
      #   {% endherounit %}</p>"
      def is_liquid_tag?(string)
        /<p>\s*{%.*%}+\s*<\/p>/m === string
      end

      # Example:
      #   "{: .class.next__class.another--class, #id, data:{content: "test"}, style: "display: inline-block;", target: "_blank", rel: "nofollow" :}"
      def is_html_attr?(string)
        /{:.*:}/ === string
      end

      def html_attr_to_s!(str)
        HtmlAttributesParser.transform(str: str).map { |key, val| "#{key}=\"#{val}\"" }.join(' ')
      end
    end
  end
end
