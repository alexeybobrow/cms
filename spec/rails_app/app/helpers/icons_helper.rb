module IconsHelper
  def icon_tag(icon_name)
    content_tag :i, '',:class=>"glyphicon glyphicon-#{icon_name}"
  end
  alias_method :i, :icon_tag

  def icon_link_to(icon_name, *args)
    html_options = args.extract_options!
    html_options[:class] = html_options[:class].to_s + " btn btn-small"
    link_to icon_tag(icon_name), *args, html_options
  end
end
