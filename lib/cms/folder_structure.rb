module Cms
  class FolderStructure
    class << self
      def folders(pages, current)
        group_by_ancestors(filter_by_prefix(pages, current), current)
      end

      # private

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

      def filter_by_prefix(pages, prefix)
        prefix.present? ? pages.with_url_prefix(prefix) : pages
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
    end
  end
end
