require 'actionpack/action_caching'

module Cms
  module Public
    class BlogController < ::Cms::Public::BaseController
      before_action :redirect_first_pagination_page
      before_action :set_tags_with_counts

      caches_action :show, if: -> { page.published? }
      caches_action :index, :tag, :author, cache_path: -> (c) { c.request.url }

      def feed
        @articles = articles.order(posted_at: :desc)
      end

      def index
        @articles = articles.order(posted_at: :desc).page(params[:page]).per(6)
        render_not_found if params[:page].present? && @articles.empty?
      end

      def show
        page
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

      def page
        @page ||= articles(!current_user).by_slug(params[:id]).first!
      end

      def articles(only_published=true)
        scoped = Page.blog(I18n.locale)
        scoped = scoped.with_published_state if only_published
        scoped
      end

      def redirect_first_pagination_page
        redirect_to(page: nil, status: 301) if params[:page] == '1'
      end

      def set_tags_with_counts
        @tags_with_counts = articles.tags_with_counts
      end
    end
  end
end
