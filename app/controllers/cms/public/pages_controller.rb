require 'actionpack/action_caching'

module Cms
  module Public
    class PagesController < ::Cms::Public::BaseController
      caches_action :show, if: -> { page && page.published? && params[:page] !~ Cms.prevent_cache_regexp }

      def show
        UrlAliasesDispatcher.new(params[:page]).dispatch do |result, url|
          case result
          when :not_found, :primary
            then render_page_for_visitor
          else #:alias
            redirect_to url.page.url, status: 301
          end
        end
      end

      private

      def page
        page_scope.with_url(Cms::UrlHelper.normalize_url(params[:page]))
      end

      def render_page_for_visitor
        @page = page_scope.public_get params[:page]
        render text: @page.body, content_type: 'text/plain' if @page.text?
      end

      def page_scope
        current_user ? Page.all : Page.with_published_state
      end
    end
  end
end
