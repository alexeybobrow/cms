module Cms
  module LiquidHelper
    def render_fragment(slug)
      fragment = ::Fragment.where(slug: slug).first
      if fragment
        apply_format(fragment.body, fragment.markup_language)
      end
    end

    def template_variables
      @template_variables ||= Cms::Liquid::TemplateVariables.new
    end

    def template_variables_to_data_hash
      template_variables.reduce({}) do |data, (k, v)|
        key = 'data-' + k.downcase.dasherize
        data[key] = v
        data
      end
    end
  end
end
