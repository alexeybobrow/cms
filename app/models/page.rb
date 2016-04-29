class Page < ActiveRecord::Base
  include Cms::SafeDelete
  include Workflow

  workflow do
    state :draft do
      event :publish, transitions_to: :published
      event :safe_delete, transitions_to: :safely_deleted
    end

    state :published do
      event :unpublish, transitions_to: :draft
      event :safe_delete, transitions_to: :safely_deleted
    end

    state :safely_deleted do
      event :restore, transitions_to: :draft
    end
  end

  has_paper_trail only: [:title, :description, :meta, :name, :url, :deleted_at]

  class << self
    def with_url_prefix(prefix)
      where("url LIKE :prefix", prefix: "#{prefix}/%")
    end

    def scoped_with_array(name)
      ->(value){ where("EXISTS(SELECT * FROM UNNEST(#{name}) AS value WHERE REPLACE(LOWER(value), ' ', '-') IN (:value))", value: value) }
    end

    def public_get(param)
      url = Cms::UrlHelper.normalize_url(param)
      id = Integer(param) rescue 0
      actual.where("url = ? OR id = ?", url, id).first!
    end
    alias_method :public_get!, :public_get
  end

  belongs_to :content, inverse_of: :_page_as_content, dependent: :destroy
  belongs_to :annotation, class_name: 'Content', foreign_key: 'annotation_id', inverse_of: :_page_as_annotation, dependent: :destroy

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

  def restore_to(version)
    version.reify.tap {|page| page.deleted_at = nil}.save!
  end

  def translation
    self.class
      .actual
      .with_published_state
      .where(url: I18n.available_locales.map{|locale| Cms::UrlHelper.compose_url(locale, self.url)})
      .where.not(id: self.id).first
  end

end
