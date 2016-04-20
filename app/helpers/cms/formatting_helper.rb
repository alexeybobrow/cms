module Cms
  module FormattingHelper
    include Cms::HtmlFilter

    def format_page(page, options = {})
      rel = options[:short] ? page.annotation : page.content
      apply_format(rel.body, rel.markup_language)
    end

    def format_tag(article_tag)
      article_tag.downcase.gsub(/\s/, '-')
    end

    def apply_format(text, markup_language)
      case markup_language
      when 'html'
        htmlize(text)
      when 'markdown'
        markdown(text)
      end
    end

    def markdown(text)
      markdown_pipeline.call(text)[:output].to_s.html_safe
    end

    def htmlize(text)
      simple_pipeline.call(text)[:output].to_s.html_safe
    end

    def metaize(text)
      meta_pipeline.call(text)[:output].to_s.gsub(/\s+/, ' ').html_safe
    end

    def plain_preview(page)
      truncate_html remove_tags(apply_format(page.annotation.body, page.annotation.markup_language)), length: 200
    end

    def blog_preview(page)
      forbidden_tags = %w(h1 h2 h3)
      forbidden_tag_patterns = forbidden_tags.map { |tag| "<\s*#{tag}[^>]*>.*?<\s*\/\s*#{tag}\s*>" }

      remove_by_pattern(apply_format(page.annotation.body, page.annotation.markup_language), forbidden_tag_patterns)
    end

    def remove_tags(html_str, forbidden_tags=[])
      forbidden_tags = %w(img h1 h2 h3 ul)

      unclosed_tags = forbidden_tags.map { |tag| "<\s*#{tag}[^>]*>" }
      closed_tags = forbidden_tags.map { |tag| "<\s*#{tag}[^>]*>.*?<\s*\/\s*#{tag}\s*>" }
      link_with_unclosed_image_tag = "<\s*a[^>]*><\s*img[^>]*><\s*\/\s*a\s*>"
      p_with_unclosed_image_tag = "<\s*p[^>]*><\s*a[^>]*><\s*img[^>]*><\s*\/\s*a\s*><\s*\/\s*p\s*>"
      p_with_image_tag = "<\s*p[^>]*><\s*a[^>]*><\s*img[^>]*>[^<]*<\s*\/\s*img\s*><\s*\/\s*a\s*><\s*\/\s*p\s*>"
      link_with_image_tag = "<\s*a[^>]*><\s*img[^>]*>[^<]*<\s*\/\s*img\s*><\s*\/\s*a\s*>"

      forbidden_tag_patterns = ([] <<
        p_with_image_tag <<
        p_with_unclosed_image_tag <<
        link_with_image_tag <<
        link_with_unclosed_image_tag) +
        closed_tags +
        unclosed_tags

      remove_by_pattern(html_str, forbidden_tag_patterns)
    end

    private

    def remove_by_pattern(html_str, pattern)
      html_str.gsub(Regexp.new(pattern.join('|'), Regexp::MULTILINE), '')
    end
  end
end
