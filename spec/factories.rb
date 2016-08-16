require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user_#{n}" }

    trait :admin do
      is_admin true
    end

    trait :locked do
      is_locked true
    end

    trait :deleted do
      deleted_at { 1.hour.ago }
    end
  end

  factory :url do
    name { "/" + Faker::Internet.slug(nil, '-') }
    primary true
  end

  factory :liquid_variable do
    name 'width'
    value '100px'
  end

  factory :occupation do
    name 'Software engineering'
  end

  factory :content do
    body { Faker::Lorem.paragraphs.join("\n\n") }

    trait :html do
      markup_language 'html'
    end

    factory :content_html, traits: [:html]
  end

  factory :page do
    sequence(:title) { |n| "Page #{n}" }
    name { title }
    meta []
    workflow_state 'published'

    content
    annotation factory: :content

    transient do
      content_body { Faker::Lorem.paragraphs.join("\n\n") }
      annotation_body { Faker::Lorem.paragraphs.join("\n\n") }
      url { "/" + title.to_s.downcase.gsub(/ /,'_') }
      user nil
    end

    after(:build) do |page, evaluator|
      if evaluator.content_body.present?
        page.content.update_column(:body, evaluator.content_body)
      end

      if evaluator.annotation_body.present?
        page.annotation.update_column(:body, evaluator.annotation_body)
      end

      page.urls = build_list(:url, 1, page: page, name: evaluator.url)
      page.primary_url = page.urls.first
    end

    trait :html do
      content factory: :content_html
    end

    trait :draft do
      workflow_state 'draft'
    end

    trait :blog do
      sequence(:title) { |n| "Blog article #{n}" }
      url { "/blog/#{user.try(:username) || 'unk'}/#{title.to_s.downcase.gsub(/ /,'_')}" }
    end

    trait :root do
      url '/'
    end

    trait :deleted do
      deleted_at { 1.hour.ago }
    end
  end

  factory :fragment do
    sequence(:slug) { |n| "slug_#{n}" }

    content

    transient do
      content_body { Faker::Lorem.paragraphs.join("\n\n") }
    end

    after(:build) do |page, evaluator|
      if evaluator.content_body.present?
        page.content.update_column(:body, evaluator.content_body)
      end
    end
  end

end
