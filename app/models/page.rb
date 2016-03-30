class Page < ActiveRecord::Base
  include SafeDelete
  include Workflow

  workflow do
    state :draft do
      event :publish, :transitions_to => :published
    end
    state :published do
      event :unpublish, :transitions_to => :draft
    end
  end

  has_paper_trail only: [:title, :meta, :name, :url, :deleted_at]

  class << self
    def scoped_with_array(name)
      ->(value){ where("EXISTS(SELECT * FROM UNNEST(#{name}) AS value WHERE REPLACE(LOWER(value), ' ', '-') = :value)", value: value) }
    end

    def public_get(url)
      actual.where(url: Cms::UrlHelper.normalize_url(url)).first!
    end
  end

  belongs_to :content, dependent: :destroy
  belongs_to :annotation, class_name: 'Content', foreign_key: 'annotation_id', dependent: :destroy

  accepts_nested_attributes_for :content
  accepts_nested_attributes_for :annotation

  default_value_for :posted_at do
    Time.now
  end

  scope :for_admin,        ->(show = nil){ actual(show).order(:url) }
  scope :blog,             ->(locale){
                               prefix = locale.to_s == 'en' ? '' : "/#{locale}"
                               where("url LIKE '#{prefix}/blog/%'").actual
                             }
  scope :ordered_blog,     ->(locale){ blog(locale).order(posted_at: :desc) }
  scope :by_slug,          ->(s){ where('url like ?', "%#{s}") }
  scope :without,          ->(page){ where.not(id: page.id) }
  scope :tags_with_counts, ->(){ select('COUNT(id) AS count, UNNEST(tags) AS tag_name').group('tag_name').order('tag_name') }
  scope :by_tag,           scoped_with_array(:tags)
  scope :by_author,        scoped_with_array(:authors)

  def root?
    url.in? %w(/ /ru)
  end

  def parent_url
    url.gsub(/\/[\w\-\.]*\z/, '')
  end

  def restore_to(version)
    version.reify.tap {|page| page.deleted_at = nil}.save!
  end

  def naming
    self.name.present? ? self.name : self.title
  end

  def translation
    self.class
      .actual
      .with_published_state
      .where(url: I18n.available_locales.map{|locale| Cms::UrlHelper.compose_url(locale, self.url)})
      .where.not(id: self.id).first
  end
end
