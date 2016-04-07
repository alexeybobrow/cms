module Auth
  class SessionsController < ::ApplicationController
    force_ssl unless Rails.env.test? || Rails.env.development?

    before_filter :not_logged_in!, only: [:new, :create]

    def new
      @session = Session.new
    end

    def create
      @session = Session.new params[:session]
      if @session.valid?
        session[:user_id] = @session.user.id
        redirect_to session[:return_to] || admin_root_url
      else
        render :new
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_url
    end
  end
end
