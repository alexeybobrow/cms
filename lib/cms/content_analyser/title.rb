module Cms::ContentAnalyser
  class Title < ::Cms::ContentAnalyser::Base
    def run
      return unless content

      html_doc = Nokogiri::HTML(CommonMarker.render_doc(content).to_html(:UNSAFE))
      if h1 = html_doc.xpath('//h1').first
        h1.text
      end
    end
  end
end
