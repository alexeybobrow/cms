module Cms::PagePropPopulator
  class Title
    attr_reader :text
    attr_reader :model
    attr_reader :prop

    class << self
      def populate(model, prop, content)
        self.new(model, prop, content).populate
      end
    end

    def initialize(model, prop, content)
      @text = analyser.read(content)
      @model = model
      @prop = prop
    end

    def populate
      if text
        model[prop] = text
      end
    end

    def analyser
      Cms::ContentAnalyser::Title
    end
  end
end
