module Cms
  class FailureAppController < BaseController
    def not_found
      render status: 404
    end
  end
end
