module Cms
  module Public
    class PagesController < ::Cms::Public::BaseController
      def show
        ::Cms::PageDispatcher.new(params[:page]).dispatch do |action|
          case action
          when :page_slug
            @page = pages.public_get params[:page]
          when :page_id
            @page = pages.find params[:page]
          end
        end
      end

      private

      def pages
        current_user ? Page.all : Page.with_published_state
      end
    end
  end
end
