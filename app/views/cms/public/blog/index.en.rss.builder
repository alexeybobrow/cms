xml.instruct! :xml, version: "1.0"
xml.rss :version => "2.0", :'xmlns:atom' =>"http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title t('public.feed.title')
    xml.description t('public.feed.description')
    xml.language I18n.locale.to_s
    xml.link blog_index_url
    xml.atom :link, href: blog_index_url(format: "rss"), rel: "self", type: "application/rss+xml"

    @articles.limit(100).each do |article|
      xml.item do
        xml.title article.name
        xml.pubDate article.posted_at.to_s(:rfc822)
        xml.link URI::HTTP.build(:host => Cms.host, :path => article.url).to_s
        xml.guid Digest::MD5.hexdigest("shonibudsboku#{article.id}iszadi"), isPermaLink: false
        xml.description blog_preview(article)

        article.tags.each do |article_tag|
          xml.category article_tag
        end
      end
    end
  end
end
