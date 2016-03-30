class Fragment < ActiveRecord::Base
  belongs_to :content, autosave: true, dependent: :destroy
  delegate :body, :markup_language, to: :content
  accepts_nested_attributes_for :content
end
