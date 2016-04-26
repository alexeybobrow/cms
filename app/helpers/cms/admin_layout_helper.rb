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

    def pages_as_folders(pages, folder)
      Cms::FolderStructure.folders(pages, folder)
    end

    def folder_breadcrumbs(folder)
      if folder
        path = folder.split('/').reject(&:empty?)
        current_folder = path.pop
        path_with_parent = path.reduce([]) {|acc, v| acc << "#{acc.last.to_s}/#{v}" }

        path.zip(path_with_parent).map do |(name, link)|
          link_to "/#{name}", admin_pages_path(folder: link)
        end
        .join()
        .concat("/#{current_folder}")
        .html_safe
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
