module Cms
  class UrlHelper
    class << self
      def normalize_url(url)
        url = prepend_slash_if_missing(url.to_s.downcase.strip)
        url = trim_trailing_slash(url)
        url
      end

      def locale_from_url(url)
        if match = normalize_url(url).match(locale_regex)
          match.captures.first
        end
      end

      def url_without_locale(url)
        url.gsub(locale_regex, '/')
      end

      def compose_url(locale, url)
        prefix = locale.to_s == 'en' ? '' : locale.to_s
        normalize_url("#{prefix}#{url_without_locale(url)}")
      end

      #private

      def locale_regex
        /\A\/(#{I18n.available_locales.join('|')})(\/|\z)/
      end

      def prepend_slash_if_missing(url)
        url.starts_with?('/') ? url : "/#{url}"
      end

      def trim_trailing_slash(url)
        url == '/' ? url : url.gsub(/\/$/, '')
      end
    end
  end
end
