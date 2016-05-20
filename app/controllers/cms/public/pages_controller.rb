module Cms
  module Public
    class PagesController < ::Cms::Public::BaseController
      def show
        UrlAliasesDispatcher.new(params[:page]).dispatch do |result, url|
          case result
          when :not_found, :primary
            then load_page
          else #:alias
            redirect_to url.page.url
          end
        end
      end

      private

      def load_page
        scoped = current_user ? Page.all : Page.with_published_state
        @page = scoped.public_get params[:page]
      end
    end
  end
end
