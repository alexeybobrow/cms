module Cms
  module SafeDelete
    extend ActiveSupport::Concern

    module ClassMethods
      def actual(show = nil)
        case show
          when nil, :actual, 'actual' then where(:deleted_at => nil)
          when :deleted, 'deleted' then where("#{quoted_table_name}.deleted_at IS NOT NULL")
          when :all, 'all' then all
        end
      end
    end

    def deleted?
      !!deleted_at
    end

    def safe_delete
      set_deleted_at!(Time.current)
    end

    def restore
      set_deleted_at!(nil)
    end

    private

    def set_deleted_at!(value)
      run_callbacks(:update) do
        self.deleted_at = value
        self.save!
      end
    end
  end
end
