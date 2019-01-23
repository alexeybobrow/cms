module Cms
  module Liquid
    class HtmlRenderer < CommonMarker::HtmlRenderer
      def initialize(options: :UNSAFE)
        super
        @attrs = ''
      end

      def header(node)
        block do
          container("<h#{node.header_level} #{sourcepos(node)}#{@attrs}>\n", "</h#{node.header_level}>") do
            out(:children)
          end
        end
      end

      def link(node)
        if is_html_attr?(node.next.string_content)
          @attrs = html_attr_to_s?(node.next.string_content)
          if /_blank/ === @attrs
            @attrs << ' rel="noopener noreferrer"'
          end
          node.next.string_content = ''
        end
        out('<a href="', node.url.nil? ? '' : escape_href(node.url), '"')
        if node.title && !node.title.empty?
          out(' title="', escape_html(node.title), '"')
        end
        out("#{@attrs}>", :children, '</a>')
      end

      def paragraph(node)
        if is_liquid_tag?(node)
          out(:children)
        elsif is_html_attr?(node.first_child.string_content)
          @attrs = html_attr_to_s?(node.first_child.string_content)

          if  node.first_child.next === nil
            node.first_child.delete
          else
            block do
              container("<p #{sourcepos(node)}#{@attrs}>\n", '</p>') do
                node.first_child.delete
                out(:children)
              end
            end
          end
        else
          super
        end
      end

      private

      # Example:
      #   "{% layout width: 600px %}"
      def is_liquid_tag?(node)
        /{%.*%}/ === node.first_child.string_content
      end

      # Example:
      #   "{: .class.next__class.another--class, #id, data:{content: "test"}, style: "display: inline-block;", target="_blank" }"
      def is_html_attr?(string)
        /{:.*}/ === string
      end

      def html_attr_to_s?(str)
        HtmlAttributesParser.transform(str: str).map { |key, val| "#{key}='#{val}'" }.join(' ')
      end
    end
  end
end
