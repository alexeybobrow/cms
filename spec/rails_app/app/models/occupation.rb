class Occupation < ActiveRecord::Base
  include SafeDelete
  
  translates :name
  has_many :employees
  globalize_accessors
  acts_as_list top_of_list: 0
  default_scope { includes(:translations).order(position: :asc) }
end
