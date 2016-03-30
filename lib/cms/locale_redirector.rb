module Cms
  class LocaleRedirector
    def call(params, request)
      "/#{params[:page]}#{query_string(request)}"
    end

    private

    def query_string(request)
      request.query_string.present? ? "?#{request.query_string}" : ""
    end
  end
end
