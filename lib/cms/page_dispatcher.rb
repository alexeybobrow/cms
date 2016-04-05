module Cms
  class PageDispatcher
    def initialize(path)
      @path = path
    end

    def dispatch
      case @path
      when /\A\d+\z/
        yield :page_id
      else
        yield :page_slug
      end
    end
  end
end
