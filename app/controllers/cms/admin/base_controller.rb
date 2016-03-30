module Cms
  module Admin
    class BaseController < ::Cms::BaseController
      force_ssl unless Rails.env.test? || Rails.env.development?
      layout 'admin/base'
      helper 'cms/safe_delete'

      before_filter :authenticate!, :set_locale

      private

      def set_locale
        I18n.locale = 'en'
      end
    end
  end
end
