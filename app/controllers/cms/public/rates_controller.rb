module Cms
  module Public
    class RatesController < ::Cms::Public::BaseController
      def create
        session[:user_rated_posts] ||= []

        unless session[:user_rated_posts].include?(params[:page_id])
          @rate = Rate.create(page_id: params[:page_id], value: params[:rate])
          session[:user_rated_posts] << params[:page_id]
        end

        if @rate.valid?
          respond_to do |format|
            format.html do
              redirect_to :back
            end
            format.json do
              render json: { rating: @rate.page.average_rate, votes: @rate.page.rates.size }
            end
          end
        else
          respond_to do |format|
            format.html do
              head :unprocessable_entity
            end
            format.json do
              render json: { error: @rate.errors.full_messages }, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end
end
