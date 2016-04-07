json.body format(@article)
json.date l(@article.created_at, format: :long)
json.tags @article.tags
