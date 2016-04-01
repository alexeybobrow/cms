module Cms
  class BaseController < ::ApplicationController
    include PolicyHelper

    helper 'cms/application'
    helper 'cms/formatting'
    helper 'cms/fragment'

    helper_method :check_policy

    helper_method :method_missing
    def method_missing(name, *args, &block)
      if name =~ /_url$|_path$/ && main_app.respond_to?(name)
        main_app.send(name, *args, &block)
      else
        super
      end
    end
  end
end
