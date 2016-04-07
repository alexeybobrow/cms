module Tags
  class BlogPosts < Cms::Liquid::Tags::Base
    def render(context)
      @context = context
      render_haml(template_content, posts: posts)
    end

    private

    def posts_limit
      limit = @attributes['limit']
      limit ? limit.to_i : 4
    end

    def posts
      current_page = view.instance_variable_get(:@page)

      scoped = Page.ordered_blog(I18n.locale).with_published_state
      scoped = scoped.without(current_page) if current_page
      scoped.limit(posts_limit)
    end

    def template_content
      ::Liquid::Template.file_system.read_template_file('blog_posts', {})
    end
  end
end

::Liquid::Template.register_tag('blog_posts', Tags::BlogPosts)
