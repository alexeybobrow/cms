module Cms
  module Public
    class RatesController < ::Cms::Public::BaseController
      def create
        Rate.create(page_id: params[:page_id], value: params[:rate])
        (session[:user_rated_posts] ||= []) << params[:page_id]
        redirect_to :back
      end
    end
  end
end
