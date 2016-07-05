module Cms::PagePropPopulator
  class Base
    attr_reader :text
    attr_reader :model
    attr_reader :prop

    class << self
      def analyser
        raise NotImplementedError
      end

      def populate(model, prop, content)
        self.new(model, prop, content).populate
      end

      def analyse(content)
        self.analyser.read(content)
      end
    end

    def initialize(model, prop, content)
      @text = self.analyse(content)
      @model = model
      @prop = prop
    end

    def populate
      if text
        model[prop] = text
      end
    end

    def analyse(content)
      self.class.analyser.read(content)
    end
  end
end
