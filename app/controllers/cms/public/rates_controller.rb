module Cms
  module Public
    class RatesController < ::Cms::Public::BaseController
      def create
        session[:user_rated_posts] ||= []

        if already_rated?
          response_error
        else
          rate = Rate.new(page_id: params[:page_id], value: params[:rate])
          rate.save ? response_success(rate) : response_error(rate)
        end
      end

      private

      def response_success(rate)
        session[:user_rated_posts] << params[:page_id].to_s

        respond_to do |format|
          format.html { redirect_to :back }
          format.json { render json: { rating: rate.page.average_rate, votes: rate.page.rates.size } }
        end
      end

      def response_error(rate = nil)
        respond_to do |format|
          if rate.present?
            format.html { head :unprocessable_entity }
            format.json { render json: { error: rate.errors.full_messages }, status: :unprocessable_entity }
          else
            format.html { head :forbidden }
            format.json { head :forbidden }
          end
        end
      end

      def already_rated?
        session[:user_rated_posts].include?(params[:page_id].to_s)
      end
    end
  end
end
