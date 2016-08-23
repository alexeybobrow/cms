module Cms
  class PageMetaForm < ::Cms::BaseModelForm
    model Page

    META_REGULAR = Set['property', 'content']
    META_OPEN_GRAPH = Set['name', 'content']
    META_GROUPS = [META_REGULAR, META_OPEN_GRAPH]

    extend ArrayAccessors

    attribute :title
    attribute :name
    attribute :breadcrumb_name
    attribute :posted_at, type: Date
    attribute :tags
    attribute :authors
    attribute :meta

    attribute :override_name, type: Boolean
    attribute :override_title, type: Boolean
    attribute :override_breadcrumb_name, type: Boolean
    attribute :override_meta_tags, type: Boolean

    array_writer :tags
    array_writer :authors

    def after_initialize
      normalize_meta!
    end

    def grouped_meta
      self.meta.reduce({}) do |acc, meta|
        (acc[meta.keys.to_set] ||= []) << meta; acc
      end
    end

    def meta_index
      @meta_index ||= 0
      @meta_index += 1
    end

    def meta_field(meta)
      if meta.is_a? Hash
        OpenGraph.new(meta)
      else
        OpenGraph.new(meta_hash(meta))
      end
    end

    private

    def meta_hash(properties)
      Hash[properties.to_a.zip((0..properties.size).map{''})]
    end

    def skip_val?(value)
      '1' == value['_destroy'] || value.values.any?(&:blank?)
    end

    def normalize_meta!
      meta_values = meta.is_a?(Array) ? meta : meta.values
      self.meta = meta_values.reject { |v| skip_val?(v) }.map { |v| v.except('_destroy') }
    end

    def before_save
      Cms::ClearCache.perform(self.model)
    end
  end
end
