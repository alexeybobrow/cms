class ApplicationController < ActionController::Base
  include RescueNotFound
  include ::Auth::Helpers

  protect_from_forgery

  before_filter :set_locale
  before_filter :set_paper_trail_whodunnit

  def set_locale
    I18n.locale = Cms::UrlHelper.locale_from_url(request.path) || I18n.default_locale
  end
end
