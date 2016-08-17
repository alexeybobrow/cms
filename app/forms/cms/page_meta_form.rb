module Cms
  class PageMetaForm < ::Cms::BaseModelForm
    model Page

    extend ArrayAccessors

    attribute :title
    attribute :description
    attribute :name
    attribute :breadcrumb_name
    attribute :posted_at, type: Date
    attribute :meta
    attribute :tags
    attribute :authors
    attribute :og

    attribute :override_name, type: Boolean
    attribute :override_title, type: Boolean
    attribute :override_breadcrumb_name, type: Boolean

    array_writer :tags
    array_writer :authors

    def after_initialize
      normalize_og!
    end

    private

    def skip_val?(value)
      '1' == value['_destroy'] || value['name'].blank? || value['value'].blank?
    end

    def normalize_og!
      og_values = og.is_a?(Array) ? og : og.values
      self.og = og_values.reject {|v| skip_val?(v) }.map {|v| v.slice('name', 'value')}
    end

    def before_save
      Cms::ClearCache.perform(self.model)
    end
  end
end
