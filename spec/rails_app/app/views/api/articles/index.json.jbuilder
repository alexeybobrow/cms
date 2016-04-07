json.array! @articles do |article|
  json.body blog_preview(article)
  json.title article.title
  json.tags article.tags
  json.date l(article.created_at, format: :long)
  json.slug article.url
end
