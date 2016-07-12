module Cms
  module Populator
    extend ActiveSupport::Concern

    def do_populate(prop, options={}, &block)
      if prop.is_a?(Hash)
        options = prop
      end

      skip_populate = (options[:unless] && self.send(options[:unless])) ||
        (options[:if] && !self.send(options[:if]))

      unless skip_populate
        populator = options[:with]
        content = self.send(options[:from])

        if block
          block.call(populator.analyse(content), self)
        else
          populator.populate(self, prop, content)
        end
      end
    end

    module ClassMethods
      def populate(prop, options={}, &block)
        self.before_save do
          self.do_populate(prop, options, &block)
        end
      end
    end
  end
end
