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

    def article_tag_list(tags)
      safe_join(tags.map { |tag| article_tag_tag(tag) }, content_tag(:span, ", "))
    end

    def article_tag_tag(tag)
      link_to tag, tag_blog_index_path(tag: format_tag(tag))
    end

    def author_list(authors)
      safe_join(authors.map { |author| author_tag(author) }, content_tag(:span, ", "))
    end

    def author_tag(author)
      link_to author, author_blog_index_path(locale: I18n.locale, author: author.mb_chars.downcase.to_s.gsub(/\s/, '-')), class: 'author'
    end
  end
end
