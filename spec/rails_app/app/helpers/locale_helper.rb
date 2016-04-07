module LocaleHelper
  def link_to_locale(name, url, *args)
    uri_obj = URI.parse(url)
    url = uri_obj.relative? ? ['/', I18n.locale, url].join : URI.join(uri_obj.host, I18n.locale, uri_obj.path).to_s

    link_to name, url, *args
  end

  def locale_switch(page)
    I18n.available_locales.map do |locale|
      link_to_unless I18n.locale == locale, t("language.name.#{locale}"), translated_path(page, locale)
    end.join(' | ')
  end

  def localized_page_path(path)
    Cms::UrlHelper.compose_url(I18n.locale, path)
  end

  def translated_path(page, locale)
    if request.env['localized']
      { locale: locale }
    elsif page && page.translation
      page.translation.url
    else
      locale.to_s == 'en' ? '/' : '/ru'
    end
  end
end
