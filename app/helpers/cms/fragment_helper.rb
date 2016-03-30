module Cms
  module FragmentHelper
    def render_fragment(slug)
      fragment = ::Fragment.where(slug: slug).first
      if fragment
        apply_format(fragment.body, fragment.markup_language)
      end
    end
  end
end
