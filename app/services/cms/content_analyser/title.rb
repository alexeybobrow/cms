module Cms::ContentAnalyser
  class Title
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
      return unless content

      html_doc = Nokogiri::HTML(CommonMarker.render_doc(content).to_html)
      if h1 = html_doc.xpath("//h1").first
        h1.text
      end
    end
  end
end
