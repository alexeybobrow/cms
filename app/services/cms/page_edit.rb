module Cms
  class PageEdit
    attr_reader :params
    attr_reader :page

    def initialize(params, page)
      @params = params
      @page = page
    end

    def dispatch(form_kind)
      forms = {}

      case form_kind
      when 'url'
        forms[:page_form] = PageUrlForm.new(params[:page], page)
      when 'meta'
        forms[:page_form] = PageMetaForm.new(params[:page], page)
      when 'content'
        forms[:page_form] = ContentForm.new(params[:content], page.content)
        forms[:image_attachment_form] = ImageAttachmentForm.new(params[:image_attachment], ImageAttachment.new)
      when 'annotation'
        forms[:page_form] = ContentForm.new(params[:content], page.annotation)
        forms[:image_attachment_form] = ImageAttachmentForm.new(params[:image_attachment], ImageAttachment.new)
      end

      yield forms, form_kind
    end
  end
end
