module Cms
  module Admin
    class ImageAttachmentsController < ::Cms::Admin::BaseController
      before_filter :find_content
      before_filter :find_attachment, :find_others, except: [:create]

      def create
        attachments = image_params.fetch(:image, nil)
        respond_to do |format|
          format.js do
            @attachment = ImageAttachment.new(image: attachments.try{|p| p[0]})
            if @attachment.save
              @content.add_attachments_to_cache([@attachment.id])
              @attachment.update_attribute(:is_main, true) if @content.attachments.size == 1
            else
              render json: { result: 'error'}
            end
          end
        end
      end

      def update
        set_main if image_params[:is_main]
        @attachment.update(alt: image_params[:alt]) if image_params[:alt]

        respond_to do |format|
          format.js
        end
      end

      def destroy
        @others.first.update_attribute(:is_main, true) if @attachment.is_main && !@others.empty?

        @content.delete_attachment_from_cache(@attachment.id)
        @attachment.destroy

        respond_to do |format|
          format.js
        end
      end

      private
      def find_content
        @content = Content.find(image_params[:content_id])
      end

      def find_attachment
        @attachment = ImageAttachment.find(params[:id])
      end

      def find_others
        @others = @content.attachments - [@attachment]
      end

      def image_params
        params.require(:image_attachment).permit!
      end

      def set_main
        @others.each { |attachment| attachment.update_attribute(:is_main, false) }
        @attachment.update_attribute(:is_main, true)
      end
    end
  end
end
