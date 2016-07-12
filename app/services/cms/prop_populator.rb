module Cms
  class PropPopulator
    def self.populate(model, prop, options={})
      if prop.is_a?(Hash)
        options = prop
      end

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
