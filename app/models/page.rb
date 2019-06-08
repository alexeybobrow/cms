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

  has_paper_trail only: [:title, :name, :url, :deleted_at]

  class << self
    def with_url(name)
      where("urls.name = ?", name).first
    end

    def scoped_with_array(name)
      ->(value){
        where("EXISTS(SELECT * FROM UNNEST(#{name}) AS value WHERE REPLACE(LOWER(value), ' ', '-') IN (:value))", value: value)
      }
    end

    def public_get(param)
      url = Cms::UrlHelper.normalize_url(param)
      id = Integer(param) rescue 0

      actual
      .where("urls.name = ? OR pages.id = ?", url, id)
      .first!
    end
    alias_method :public_get!, :public_get
  end

  has_many :urls, autosave: true
  has_many :rates, dependent: :destroy
  has_one :primary_url, -> { where primary: true }, class_name: "Url", autosave: true
  belongs_to :content, inverse_of: :_page_as_content, dependent: :destroy
  belongs_to :annotation, class_name: 'Content', foreign_key: 'annotation_id', inverse_of: :_page_as_annotation, dependent: :destroy

  default_scope { joins('LEFT JOIN "urls" ON "urls"."page_id" = "pages"."id" AND "urls"."primary" = \'t\'') }

  accepts_nested_attributes_for :urls, :content, :annotation

  delegate :body, :text?, to: :content

  default_value_for :posted_at do
    Time.now
  end

  scope :for_admin,        ->(show = nil){ actual(show).order('urls.name') }
  scope :blog,             ->(locale){
                               prefix = locale.to_s == 'en' ? '' : "/#{locale}"
                               with_url_prefix("#{prefix}/blog").actual
                             }
  scope :by_slug,          ->(s){ where('urls.name like ?', "%#{s}") }
  scope :without,          ->(page){ where.not(id: page.id) }
  scope :tags_with_counts, ->(){ select('COUNT(pages.id) AS count, UNNEST(tags) AS tag_name').group('tag_name').order('tag_name') }
  scope :with_url_prefix,  ->(prefix) { where("urls.name LIKE ?", "#{prefix}/%") }
  scope :by_tag,           scoped_with_array(:tags)
  scope :by_author,        scoped_with_array(:authors)

  def set_meta(meta_hash, meta_value)
    if meta_tag = self.meta.find { |m| m.merge(meta_hash) == m }
      meta_tag.merge!(meta_value)
    else
      self.meta << meta_hash.merge(meta_value)
    end
  end

  def url
    primary_url.try(:name) || ''
  end

  def switch_primary_url(id)
    if new_primary = urls.where(id: id).first
      urls.each { |u| u.primary = (u == new_primary)}
    end
  end

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
      .where('urls.name' => I18n.available_locales.map{|locale| Cms::UrlHelper.compose_url(locale, self.url)})
      .where.not(id: self.id).first
  end

  def average_rate
    self.rates.empty? ? 0 : (self.rates.inject(0) { |sum, x| sum += x.value } / self.rates.size.to_f).round(2)
  end

  def rate!
    generate_rating if blog? && rates.empty?
  end

  def generate_rating
    rand(10..30).times { rates.create(value: 3) }
    rand(10..85).times { rates.create(value: 4) }
    rand(10..60).times { rates.create(value: 5) }
  end

  def blog?
    url.match(/\/blog\//).present?
  end
end
