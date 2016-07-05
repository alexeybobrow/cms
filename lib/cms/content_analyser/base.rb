module Cms::ContentAnalyser
  class Base
    attr_reader :content

    class << self
      def read(content)
        self.new(content).run
      end
    end

    def initialize(content)
      @content = content
    end

    def run
      raise NotImplementedError
    end
  end
end
