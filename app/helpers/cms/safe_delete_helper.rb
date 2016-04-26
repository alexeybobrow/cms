module Cms
  module SafeDeleteHelper
    def switch_deleted_link
      if params[:show] == 'all'
        link_to t('admin.hide_deleted'), url_for(params.merge(show: nil))
      else
        link_to t('admin.show_deleted'), url_for(params.merge(show: 'all'))
      end
    end
  end
end
