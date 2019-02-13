module Cms::ContentAnalyser
  class Image < ::Cms::ContentAnalyser::Base
    def run
      return unless content

      html_doc = Nokogiri::HTML(CommonMarker.render_doc(content).to_html(:UNSAFE))
      if img = html_doc.xpath('//img').first
        img.attr('src')
      end
    end
  end
end
