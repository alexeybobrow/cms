module Cms
  module Admin
    class SessionsController < ::Cms::Admin::BaseController
      def show
        render json: {
          user: current_user.as_json(only: :name),
          page: page.as_json(only: :id)
        }
      end

      private

      def page
        Page.with_url params[:page]
      end
    end
  end
end

