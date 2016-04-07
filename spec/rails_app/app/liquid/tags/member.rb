module Tags
  class Member < Cms::Liquid::Tags::Base
    include PersonInfo

    def render(context)
      <<-html
        #{avatar.render(context)}
        <div class="person-info">
          <div class="name">
            #{person_name}
          </div>
          <div class="position">
            #{person_position}
          </div>
        </div>
      html
    end

    private

    def avatar
      @avatar ||= Tags::Avatar.parse('avatar', @markup, '', {})
    end
  end
end

::Liquid::Template.register_tag('member', Tags::Member)
