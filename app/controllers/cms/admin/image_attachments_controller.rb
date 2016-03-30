module Cms
  module Admin
    class ImageAttachmentsController < ::Cms::Admin::BaseController
      def create
        attachments = image_params.fetch(:image, nil)
        respond_to do |format|
          format.js do
            @upload = ImageAttachment.new(image: attachments.try{|p| p[0]})
            if @upload.save
              render json: @upload.to_json_params
            else
              render json: { result: 'error'}
            end
          end
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
