module Auth
  module Helpers
    extend ActiveSupport::Concern

    included do
      helper_method :signed_in?, :current_user
      hide_action :signed_in?, :current_user,
        :authenticate!, :require_admin!,
        :not_logged_in!
    end

    def signed_in?
      !!current_user
    end

    def current_user
      @current_user ||= Session.get_user(session[:user_id]) if session[:user_id]
    end

    def authenticate!
      unless signed_in?
        session[:return_to] = request.url
        redirect_to main_app.sign_in_url, alert: t('auth.not_authenticated')
        return false
      end
      true
    end

    def require_admin!
      return false unless authenticate!

      unless current_user.is_admin?
        redirect_to admin_root_url, alert: t('auth.not_allowed')
      end
    end

    def not_logged_in!
      if signed_in?
        redirect_to admin_root_url, notice: t('auth.already_authenticated', name: current_user.username)
        false
      end
    end
  end
end
