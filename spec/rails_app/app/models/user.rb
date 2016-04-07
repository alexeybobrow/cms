class User < ActiveRecord::Base
  include SafeDelete

  validates :username, presence: true,
    uniqueness: true

  scope :active,     ->{ where(is_locked: false) }
  scope :for_admin,  ->(show = nil){ actual(show).order(:username) }


  def role
    is_admin? ? :admin : :regular
  end

  def name
    super.presence || username
  end

  def username=(new_username)
    super(new_username.downcase.strip)
  end

end
