module Cms
  class BaseForm
    include ActiveAttr::Model
    include ActiveAttr::TypecastedAttributes
    include ActiveAttr::AttributeDefaults

    def valid?
      clean_attributes
      @model.assign_attributes attributes
      super
    end

    def clean_attributes; end
  end
end
