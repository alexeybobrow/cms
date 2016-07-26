module Cms
  module Admin
    class CachesController < ::Cms::Admin::BaseController
      def destroy
        Rails.cache.clear
        redirect_to admin_pages_path
      end
    end
  end
end

