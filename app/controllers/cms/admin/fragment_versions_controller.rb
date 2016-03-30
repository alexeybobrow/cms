module Cms
  module Admin
    class FragmentVersionsController < ::Cms::Admin::BaseController
      before_filter :find_fragment

      def index
        @versions = @fragment.content.versions.sort_by(&:created_at)
      end

      def reify
        version = PaperTrail::Version.find(params[:id])
        version.item.restore_to(version)
        redirect_to [:admin, :fragments], notice: 'Fragment reverted'
      end

      private

      def find_fragment
        @fragment = Fragment.find(params[:fragment_id])
      end
    end
  end
end
