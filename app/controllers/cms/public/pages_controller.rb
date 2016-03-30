module Cms
  module Public
    class PagesController < ::Cms::Public::BaseController
      def show
        scoped = current_user ? Page.all : Page.with_published_state
        @page = scoped.public_get params[:page]
      end
    end
  end
end
