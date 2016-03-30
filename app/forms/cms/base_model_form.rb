module Cms
  class BaseModelForm < ::Cms::BaseForm
    class_attribute :model_class
    attr_reader :model

    self.model_class = ActiveRecord::Base

    class << self
      def model(model)
        self.model_class = model
      end

      def model_name
        self.model_class.model_name
      end
    end

    delegate :persisted?, to: :model

    def initialize(params, model)
      @model = model
      super(model.attributes.merge(params || {}))
      after_initialize
    end

    def save
      return nil unless valid?
      before_save
      @model.save and @model
    end

    def before_save; end
    def after_initialize; end
  end
end
