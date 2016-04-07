class LiquidVariable < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  def self.as_hash
    self.all.reduce({}) {|h, v| h[v.name] = v.value; h}
  end
end
