module ApplicationHelper
  include PalmisterHelper

  def flash_tag
    flash.map do |key, value|
      content_tag :div, value, class: "flash #{key}"
    end.first
  end

  def highlight_li(li)
    if request.env["REQUEST_PATH"] == li
      "selected"
    else
      ""
    end
  end

  def display_user(id)
    User.where(id: id).first.try(:username) || t('admin.system_user')
  end

  def content_class
    case response.status
    when 200
      html_class = request.path.split('/').join(' ')
      html_class << ' homepage' if @page && @page.root?
      html_class << ' project' if @page && @page.url.start_with?('/projects/')
    when 404
      html_class = 'not_found'
    else
      html_class = ''
    end

    { class: html_class }
  end

  def async_stylesheet(name)
    provide :async_stylesheet, stylesheet_path(name) + " "
  end
end
