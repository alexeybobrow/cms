module Cms
  module Admin
    class PageVersionsController < ::Cms::Admin::BaseController
      before_filter :find_page

      def index
        @versions = (@page.versions + @page.annotation.versions + @page.content.versions).sort_by(&:created_at)
      end

      def reify
        version = PaperTrail::Version.find(params[:id])
        version.item.restore_to(version)
        redirect_to [:admin, @page], notice: 'Page reverted'
      end

      private

      def find_page
        @page = Page.find(params[:page_id])
      end
    end
  end
end
