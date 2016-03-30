module Cms
  class PageUpdate < ::Cms::PageEdit
    def save(form_kind)
      dispatch(form_kind) do |forms|
        yield forms[:page_form].save, forms, form_kind
      end
    end
  end
end
