module Cms
  module Admin
    class CachesController < ::Cms::Admin::BaseController
      def destroy
        Rails.cache.clear

        if request.xhr?
          render nothing: true, status: :ok
        else
          redirect_to admin_pages_path
        end
      end
    end
  end
end

