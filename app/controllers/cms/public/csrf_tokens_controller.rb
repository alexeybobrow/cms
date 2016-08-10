module Cms
  module Public
    class CsrfTokensController < ::Cms::Public::BaseController
      def show
        render json: {
          token: form_authenticity_token
        }
      end
    end
  end
end
