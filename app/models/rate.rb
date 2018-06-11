class Rate < ActiveRecord::Base
  belongs_to :page

  validates :value, presence: true, inclusion: { in: 1..5 }
end
