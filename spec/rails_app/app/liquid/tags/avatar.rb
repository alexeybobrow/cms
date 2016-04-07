module Tags
  class Avatar < Cms::Liquid::Tags::Base
    include PersonInfo

    def render(context)
      "<img alt=\"#{person_name}\" src=\"#{person_image}\">"
    end
  end
end

::Liquid::Template.register_tag('avatar', Tags::Avatar)
