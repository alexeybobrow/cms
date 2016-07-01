module Cms
  module Populator
    extend ActiveSupport::Concern

    module ClassMethods
      def populate(prop, options)
        self.before_save do |model|
          skip_populate = options[:unless] && model.send(options[:unless])

          unless skip_populate
            populator = options[:with]
            content = model.send(options[:from])
            populator.populate(model, prop, content)
          end
        end
      end
    end
  end
end
