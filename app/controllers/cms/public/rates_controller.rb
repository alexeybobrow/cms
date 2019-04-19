module Cms
  module Public
    class RatesController < ::Cms::Public::BaseController
      before_action :find_page

      def create
        session[:user_rated_posts] ||= []

        if already_rated?
          response_success(false)
        else
          rate = @page.rates.build(value: params[:rate])
          rate.save ? response_success : response_error(rate.errors.full_messages)
        end
      end

      private

      def find_page
        @page = Page.find(params[:page_id])
      end

      def response_success(new_rate = true)
        session[:user_rated_posts] << @page.id.to_s if new_rate

        respond_to do |format|
          format.html { redirect_to :back }
          format.json { render json: { rating: @page.average_rate, votes: @page.rates.size } }
        end
      end

      def response_error(message)
        respond_to do |format|
          format.html { head :unprocessable_entity }
          format.json { render json: { error: message }, status: :unprocessable_entity }
        end
      end

      def already_rated?
        session[:user_rated_posts].include?(@page.id.to_s)
      end
    end
  end
end
