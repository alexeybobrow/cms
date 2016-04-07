module Cms
  module ArrayAccessors
    extend ActiveSupport::Concern

    def array_writer(attr_name)
      define_method :"#{attr_name}=" do |value|
        if Enumerable === value
          super(value)
        else
          super(value.to_s.split(/,/).map(&:strip))
        end
      end
    end

    def array_reader(attr_name)
      define_method :"#{attr_name}" do
        value = super()
        if Enumerable === value
          value.join(', ')
        else
          value.to_s
        end
      end
    end

    def array_accessor(attr_name)
      array_reader(attr_name)
      array_writer(attr_name)
    end
  end
end
