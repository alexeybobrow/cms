module Cms
  module AdminLayoutHelper
    def page_html_class(page)
      case page.current_state.to_s
        when 'safely_deleted'
          'danger'
        when 'draft'
          'warning'
        else ''
      end
    end

    def page_name(page)
      page.name.presence || page.title.presence || t('admin.pages.untitled')
    end

    def url_label(url, prefix)
      url.gsub(/\A#{prefix}/, '')
    end

    def can_publish_page?(page)
      check_policy(PublicationPolicy, page, :publish?)
    end

    def check_disabled(page)
      'disabled' unless can_publish_page?(page)
    end
  end
end
