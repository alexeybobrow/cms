module Cms
  module Public
    class RatesController < ::Cms::Public::BaseController
      def create
        session[:user_rated_posts] ||= []
        
        unless session[:user_rated_posts].include?(params[:page_id])
          Rate.create(page_id: params[:page_id], value: params[:rate])
          session[:user_rated_posts] << params[:page_id]
        end

        redirect_to :back
      end
    end
  end
end
