module Cms
  class PageMetaForm < ::Cms::BaseModelForm
    model Page

    extend ArrayAccessors

    attribute :title
    attribute :description
    attribute :name
    attribute :breadcrumb_name
    attribute :posted_at, type: Date
    attribute :raw_meta
    attribute :tags
    attribute :authors
    attribute :meta

    attribute :override_name, type: Boolean
    attribute :override_title, type: Boolean
    attribute :override_breadcrumb_name, type: Boolean

    array_writer :tags
    array_writer :authors

    def after_initialize
      normalize_meta!
    end

    private

    def skip_val?(value)
      '1' == value['_destroy'] || value['name'].blank? || value['value'].blank?
    end

    def normalize_meta!
      meta_values = meta.is_a?(Array) ? meta : meta.values
      self.meta = meta_values.reject {|v| skip_val?(v) }.map {|v| v.slice('name', 'value')}
    end

    def before_save
      Cms::ClearCache.perform(self.model)
    end
  end
end
