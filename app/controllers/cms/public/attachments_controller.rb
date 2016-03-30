module Cms
  module Public
    class AttachmentsController < ::Cms::Public::BaseController
      def download
        attachment = ImageAttachment.where(id: params[:id])
        file_path = attachment ? attachment.file_path(params[:basename], params[:extension]) : nil

        if file_path && attachment.available?
          content_type = Mime::Type.lookup_by_extension(params[:extension]).to_s
          send_data open(file_path, "rb") { |f| f.read }, type: content_type, disposition: 'inline'
        else
          render nothing: true, status: 404
        end
      end
    end
  end
end
