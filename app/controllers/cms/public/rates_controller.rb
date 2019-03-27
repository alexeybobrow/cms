module Cms
  module Public
    class RatesController < ::Cms::Public::BaseController
      def create
        session[:user_rated_posts] ||= []

        unless session[:user_rated_posts].include?(params[:page_id])
          @rate = Rate.create(page_id: params[:page_id], value: params[:rate])
          session[:user_rated_posts] << params[:page_id]
        end

        render :json => { rating: @rate.page.average_rate, votes: @rate.page.rates&.size }
      end
    end
  end
end
