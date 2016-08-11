module Cms
  module Admin
    class CachesController < ::Cms::Admin::BaseController
      def destroy
        Cms::ClearCache.perform

        if request.xhr?
          render status: :ok, json: { flash: { type: :notice, message: flash_message } }
        else
          flash[:notice] = flash_message
          redirect_to admin_pages_path
        end
      end

      private

      def flash_message
        "Cache was successfully cleared."
      end
    end
  end
end

