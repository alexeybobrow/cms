module Cms
  module Populator
    extend ActiveSupport::Concern

    module ClassMethods
      def populate(prop, options={})
        if prop.is_a?(Hash)
          options = prop
        end

        self.before_save do |model|
          skip_populate = (options[:unless] && model.send(options[:unless])) ||
            (options[:if] && !model.send(options[:if]))

          unless skip_populate
            populator = options[:with]
            content = model.send(options[:from])

            if block_given?
              yield populator.analyse(content), model
            else
              populator.populate(model, prop, content)
            end
          end
        end
      end
    end
  end
end
