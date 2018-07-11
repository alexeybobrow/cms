module Cms
  module Admin
    class ImageAttachmentsController < ::Cms::Admin::BaseController
      def create
        attachments = image_params.fetch(:image, nil)
        content = Content.find(image_params[:content_id])
        respond_to do |format|
          format.js do
            @upload = ImageAttachment.new(image: attachments.try{|p| p[0]})
            if @upload.save
              content.add_attachments_to_cache([@upload.id])
              @upload.update_attribute(:is_main, true) if content.attachments.size == 1
              @attachments = content.attachments.map(&:id)
            else
              render json: { result: 'error'}
            end
          end
        end
      end

      def edit
        @upload = ImageAttachment.find(params[:id])
        @attachments = image_params[:attachments].split(' ').map{ |id| ImageAttachment.find(id) } - [@upload]

        @attachments.each{ |attachment| attachment.update_attribute(:is_main, false) }
        @upload.update_attribute(:is_main, true)

        respond_to do |format|
          format.js
        end
      end

      def destroy
        @upload = ImageAttachment.find(params[:id])
        @upload.remove
        respond_to do |format|
          format.js
        end
      end

      def restore
        @upload = ImageAttachment.find(params[:image_attachment_id])
        @upload.restore
      end

      private

      def image_params
        params.require(:image_attachment).permit!
      end
    end
  end
end
