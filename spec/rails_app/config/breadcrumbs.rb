crumb :root do
  link I18n.t('breadcrumbs.home'), I18n.locale.to_s == 'en' ? '/' : "/#{I18n.locale}"
end

crumb :page do |page|
  link page.breadcrumb_name, page.url

  unless Cms::UrlHelper.parent_url(page.url).in? ['/', '/ru', '']
    if parent_page = Page.with_published_state.public_get(Cms::UrlHelper.parent_url(page.url))
      parent :page, parent_page
    end
  end
end

crumb :blog do
  link I18n.t('breadcrumbs.blog'), blog_index_path(locale: I18n.locale)
end

crumb :blog_post do |article|
  link article.breadcrumb_name, article.url
  parent :blog
end

crumb :not_found do
  link I18n.t('breadcrumbs.not_found')
end
