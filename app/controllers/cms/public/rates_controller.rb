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
          responce_success(@rate)
        else
          responce_error(@rate)
        end
      end

      private

      def responce_success(rate)
        respond_to do |format|
          format.html { redirect_to :back }
          format.json { render json: { rating: rate.page.average_rate, votes: rate.page.rates.size } }
        end
      end

      def responce_error(rate)
        respond_to do |format|
          format.html { head :unprocessable_entity }
          format.json { render json: { error: rate.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end
  end
end
