module Tags
  class Team < Cms::Liquid::Tags::Base
    def render(context)
      "<ul>#{team_html(context)}</ul>"
    end

    private

    def team_html(context)
      unquote(@markup).split(/'\s'/).map do |employee_name|
        '<li>' + Tags::Member.parse('member', employee_name, '', {}).render(context) + '</li>'
      end.join
    end
  end
end

::Liquid::Template.register_tag('team', Tags::Team)
