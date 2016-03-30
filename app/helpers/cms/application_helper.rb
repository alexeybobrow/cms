module Cms
  module ApplicationHelper
    def display_changes(field, from, to)
      if field == 'body'
        render 'cms/admin/shared/versions/body_changes', from: from, to: to
      else
        t('admin.history.change_notice',
            field: content_tag(:strong, field.humanize),
            from: content_tag(:span, from, class: 'only_a'),
            to: content_tag(:span, to, class: 'only_b')
         ).html_safe
      end
    end
  end
end
