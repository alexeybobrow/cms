module Cms
  module Admin
    class UrlsController < ::Cms::Admin::BaseController
      def destroy
        page = Page.find params[:page_id]
        url = page.urls.find params[:id]
        url.destroy unless url.primary?
        redirect_to edit_admin_page_url(page, form_kind: :url)
      end
    end
  end
end

