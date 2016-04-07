module Auth
  class Base
    include ::ActiveAttr::Model
    attribute :username
    attribute :password

    validate :authentication

    class << self
      def get_user(id)
        scope.where(id: id).first
      end

      def scope
        User.active
      end

      def model_name
        ActiveModel::Name.new(OpenStruct.new(name: 'Session'))
      end
    end

    def user
      self.class.scope.where(username: username).first
    end

    protected

    def authentication
      errors.add :base, :auth_failure unless authenticated?
    end

    def authenticated?
      !!user
    end

  end
end

Session = Auth::Base
