module Cms
  module Public
    class BlogController < ::Cms::Public::BaseController
      respond_to :html, :rss
      before_action :set_tags_with_counts

      def index
        @articles = articles.order(posted_at: :desc).page(params[:page]).per(4)
        respond_with @articles
      end

      def show
        @page = articles(!current_user).by_slug(params[:id]).first!
      end

      def tag
        @articles = articles.order(posted_at: :desc).by_tag(params[:tag]).page(params[:page]).per(4)
        render :index
      end

      def author
        @articles = articles.order(posted_at: :desc).by_author(params[:author]).page(params[:page]).per(4)
        render :index
      end

      private

      def articles(only_published=true)
        scoped = Page.blog(I18n.locale)
        scoped = scoped.with_published_state if only_published
        scoped
      end

      def set_tags_with_counts
        @tags_with_counts = articles.tags_with_counts
      end
    end
  end
end
