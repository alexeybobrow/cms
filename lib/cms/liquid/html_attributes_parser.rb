# Parse html attributes
# Example:
#   "{: .class, #id, role: 'tabpanel', data:{handler: 'toggle'}, aria:{labelledby: 'ch1Tab'} :}"

module Cms
  module Liquid
    class HtmlAttributesParser
      private_class_method :new

      def self.transform(str: '')
        return {} if str.blank? || !str.is_a?(String)
        new(str).call
      end

      def initialize(str)
        @string = str
      end

      def call
        str = @string[BODY_REGEXP]
        class_names = str.scan(CLASS_REGEXP) || []
        id = str.scan(ID_REGEXP).first || ''
        tmp_hash = other_params_to_hash(str, class_names, id)
        base_h = [
            [:class, class_names.join(' ')],
            [:id, id],
            *tmp_hash.except(:data).keys.map { |key| [key, tmp_hash[key]] },
            *generate_data_attributes(tmp_hash[:data])
        ].to_h
        base_h.reject { |_key, value| !value.present? }
      end

      private

      BODY_REGEXP = /(?<={:).*?(?=:})/
      CLASS_REGEXP = /(?<=\.)-?[_a-zA-Z]+[_a-zA-Z0-9-]*/
      ID_REGEXP = /(?<=#)-?[_a-zA-Z]+[_a-zA-Z0-9-]*/

      def other_params_to_hash(string, class_names, id)
        begin
          Hash.instance_eval("{#{
            string.gsub(".#{class_names.join('.')}", '')
              .gsub("##{id}", '')
              .split(',')
              .delete_if { |item| !item.present? }
              .join(',')
          }}")
        rescue SyntaxError => _e
          {}
        end
      end

      def generate_data_attributes(hash)
        return {} unless hash.present?
        hash.keys.map { |key| ["data-#{key.to_s}", hash[key]] }
      end
    end
  end
end