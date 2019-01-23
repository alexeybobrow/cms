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

      def paragraph(node)
        if is_liquid_tag?(node)
          out(:children)
        elsif is_html_attr?(node)
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
      #   "{ .class.next__class.another--class, #id, data:{content: "test"}, style: "display: inline-block;" }"
      def is_html_attr?(node)
        /{[^%].*}/ === node.first_child.string_content
      end

      def html_attr_to_s?(str)
        HtmlAttributesParser.transform(str: str).map { |key, val| "#{key}='#{val}'" }.join(' ')
      end
    end
  end
end
