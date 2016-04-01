module Cms
  module PolicyHelper
    def policy(klass, args, check)
      -> { klass.new(args).send(check) }
    end

    def check_policy(*args)
      policy(*args).call
    end
  end
end
