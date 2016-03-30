module Cms
  module Admin
    class FragmentsController < ::Cms::Admin::BaseController
      def index
        @fragments = Fragment.all
      end

      def new
        @form = FragmentForm.new(params[:fragment], Fragment.new)
      end

      def create
        @form = FragmentForm.new(params[:fragment], Fragment.new)

        if @form.save
          redirect_to [:admin, :fragments]
        else
          render :new
        end
      end

      def edit
        @form = FragmentForm.new(params[:fragment], fragment)
        @image_attachment_form = ImageAttachmentForm.new(params[:image_attachment], ImageAttachment.new)
      end

      def update
        @form = FragmentForm.new(params[:fragment], fragment)
        @image_attachment_form = ImageAttachmentForm.new(params[:image_attachment], ImageAttachment.new)

        if @form.save
          redirect_to [:admin, :fragments]
        else
          render :edit
        end
      end

      def destroy
        fragment.destroy
        redirect_to [:admin, :fragments]
      end

      private

      def fragment
        @fragment ||= Fragment.find(params[:id])
      end
    end
  end
end
