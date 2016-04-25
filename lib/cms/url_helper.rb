module Cms
  class UrlHelper
    class << self
      LOCALE_REGEX = /\A\/(#{I18n.available_locales.join('|')})(\/|\z)/.freeze
      SLUG_REGEX = /\/([\w\-\.]*\z)/.freeze

      def normalize_url(url)
        url = prepend_slash_if_missing(url.to_s.downcase.strip)
        url = trim_trailing_slash(url)
        url
      end

      def locale_from_url(url)
        if match = normalize_url(url).match(LOCALE_REGEX)
          match.captures.first
        end
      end

      def url_without_locale(url)
        url.gsub(LOCALE_REGEX, '/')
      end

      def compose_url(locale, url)
        prefix = locale.to_s == 'en' ? '' : locale.to_s
        normalize_url("#{prefix}#{url_without_locale(url)}")
      end

      def slug(url)
        url[SLUG_REGEX, 1]
      end

      def parent_url(url)
        url.gsub(SLUG_REGEX, '')
      end

      def ancestor_url(url, prefix=nil)
        url[/(\A#{prefix}\/[\w\-\.]*)\//, 1]
      end

      def group_by_ancestors(pages, prefix=nil)
        pages.group_by do |page|
          self.ancestor_url(page.url, prefix)
        end.reduce({}) do |acc, (key, value)|
          acc[key] = key.nil? ? value : group_by_ancestors(value, key)
          sort_by_group(acc)
        end
      end

      def sort_by_group(pages)
        pages.sort do |(k1, _), (k2, _)|
          case
          when k1.nil? then 1
          when k2.nil? then -1
          else k1 <=> k2
          end
        end.to_h
      end

      #private

      def prepend_slash_if_missing(url)
        url.starts_with?('/') ? url : "/#{url}"
      end

      def trim_trailing_slash(url)
        url == '/' ? url : url.gsub(/\/$/, '')
      end
    end
  end
end
