module Cms
  module Admin
    class PagesController < ::Cms::Admin::BaseController
      before_filter :load_page, except: [:index, :new, :create]

      def index
        @pages = Page.for_admin(params[:show])
      end

      def show; end

      def new
        @page = Page.create(content: Content.new, annotation: Content.new)
        redirect_to [:edit, :admin, @page, { form_kind: 'content' }]
      end

      def create
        @form = PageUrlForm.new(params[:page], Page.new)

        if @page = @form.save
          redirect_to [:admin, @page]
        else
          render :new
        end
      end

      def edit
        PageEdit.new(params, @page).dispatch(params[:form_kind]) do |forms, form_kind|
          @form = forms[:page_form]
          @image_attachment_form = forms[:image_attachment_form]

          render "edit_#{form_kind}"
        end
      end

      def update
        PageUpdate.new(params, @page).save(params[:form_kind]) do |model, forms, form_kind|
          @form = forms[:page_form]
          @image_attachment_form = forms[:image_attachment_form]

          if model
            redirect_to [:admin, @page]
          else
            render "edit_#{form_kind}"
          end
        end
      end

      def delete; end

      def destroy
        @page.safe_delete!
        redirect_to [:admin, :pages]
      end

      def publish
        if check_policy(PublicationPolicy, @page, :publish?)
          @page.publish!
        end
        redirect_to [:admin, @page]
      end

      def unpublish
        @page.unpublish!
        redirect_to [:admin, @page]
      end

      private

      def load_page
        @page = Page.find params[:id]
      end
    end
  end
end
