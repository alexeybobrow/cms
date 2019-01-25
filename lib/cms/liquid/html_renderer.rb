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
        if is_html_attr?(node.next.to_html)
          @attrs = html_attr_to_s?(node.next.to_html)
          if /_blank/ === @attrs
            if /nofollow/ === @attrs
              @attrs = @attrs.gsub(/rel='nofollow'/, 'rel="noopener noreferrer nofollow"')
            else
              @attrs << ' rel="noopener noreferrer"'
            end
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
        if is_liquid_tag?(node.to_html)
          out(:children)
        elsif is_html_attr?(node.to_html)
          @attrs = html_attr_to_s?(node.to_html)
          if node.first_child.next === nil
            node.first_child.delete
          elsif @in_tight && node.parent.type != :blockquote
              out(:children)
            else
              block do
                container("<p#{sourcepos(node)}>", '</p>') do
                  out(:children)
                  if node.parent.type == :footnote_definition && node.next.nil?
                    out(" ")
                    out_footnote_backref
                  end
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
      def is_liquid_tag?(string)
        /{%.*%}/ === string
      end

      # Example:
      #   "{: .class.next__class.another--class, #id, data:{content: "test"}, style: "display: inline-block;", target: "_blank", rel: "nofollow" :}"
      def is_html_attr?(string)
        /{:.*:}/ === string
      end

      def html_attr_to_s?(str)
        HtmlAttributesParser.transform(str: str).map { |key, val| "#{key}='#{val}'" }.join(' ')
      end
    end
  end
end
