module Cms
  class ClearCache
    cattr_accessor :around_perform do
      ->(options, &perform) { perform.call }
    end

    class << self
      def configure
        yield self
      end

      def perform(options={})
        self.around_perform.call(options) do
          new.perform
        end
      end
    end

    def perform
      Rails.cache.clear
    end
  end
end
