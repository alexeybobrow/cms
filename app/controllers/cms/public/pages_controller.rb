require 'actionpack/action_caching'

module Cms
  module Public
    class PagesController < ::Cms::Public::BaseController
      caches_action :show, if: -> { page.published? }

      def show
        UrlAliasesDispatcher.new(params[:page]).dispatch do |result, url|
          case result
          when :not_found, :primary
            then page
          else #:alias
            redirect_to url.page.url, status: 301
          end
        end
      end

      private

      def page
        @page ||= page_scope.public_get params[:page]
      end

      def page_scope
        current_user ? Page.all : Page.with_published_state
      end
    end
  end
end
