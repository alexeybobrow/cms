class Url < ActiveRecord::Base
  include Cms::Populator

  belongs_to :page

  delegate :body, to: :page

  populate with: Cms::PagePropPopulator::Url, from: :body do |text, model|
    if text.present?
      model.name = text
    end
  end
end
