module Cms
  module SafeDeleteHelper
    def switch_deleted_link
      if params[:show] == 'all'
        link_to t('admin.hide_deleted'), show: nil
      else
        link_to t('admin.show_deleted'), show: 'all'
      end
    end
  end
end
