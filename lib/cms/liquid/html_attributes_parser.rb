# Parse html attributes
# Example:
#   "{: .class.next__class.another--class, #id, style: "display: inline-block;", target: "_blank", rel: "nofollow", data: {content: "test", handler: 'toggle'}, aria: {labelledby: 'ch1Tab'} :}"
#
require 'strscan'

module Cms
  module Liquid
    class HtmlAttributesParser
      private_class_method :new

      BODY_REGEX = /(?<={:).*?(?=:})/.freeze
      ALLOWED_SYMBOLS = /-?[_a-zA-Z]+[_a-zA-Z0-9-]*/.freeze
      CLASS_REGEX = /(?<=\.)#{ALLOWED_SYMBOLS}/.freeze
      ID_REGEX = /(?<=#)#{ALLOWED_SYMBOLS}/.freeze
      # {content:  'test', test: 'test'}
      DATA_ATTRIBUTES_VALUES_REGEX = /{(?:(?!}).)*}/.freeze
      # DATA_ATTRIBUTES_VALID_VALUES_REGEX = /{(?:(?!}).[^{}])*}/.freeze
      # data: {content:  'test', test: 'test'}
      DATA_ATTRIBUTES_REGEX = /(?:data:\s*)#{DATA_ATTRIBUTES_VALUES_REGEX}/.freeze
      # aria: {content:  'test', test: 'test'}
      ARIA_ATTRIBUTES_REGEX = /(?:aria:\s*)#{DATA_ATTRIBUTES_VALUES_REGEX}/.freeze
      # data:
      ATTRIBUTES_KEY_REGEX = /#{ALLOWED_SYMBOLS}(?=:)/.freeze
      # 'display: inline-block;'
      ATTRIBUTES_VALUES_REGEX = /(?:')(?:(?!').)*'/.freeze
      # https://html.spec.whatwg.org/multipage/syntax.html#attributes-2
      INVALID_ATTRIBUTE_NAME_REGEX = /[ \0"'>\/=]/.freeze
      # style: 'display: inline-block;'
      ATTRIBUTES_REGEX = /(\w+:\s*'(?:(?!').)*')/.freeze

      def self.transform(str: '', line: '')
        return {} if str.blank? || !str.is_a?(String)
        new(str, line).call
      end

      def initialize(str, line)
        @string = str
        @start_line = line
      end

      def call
        str = @string[BODY_REGEX]
        str.gsub!(/[‘’"“”]/,'\'')
        hash = {}

        raise SyntaxError, "HTML Attributes Syntax Error.\nRedundant brackets in the {: #{ str} :} \
                            above the #{@start_line}" if str.scan(/{/).size != str.scan(/}/).size

        begin
          hash[:id] = str.scan(ID_REGEX).first
          hash[:class] = str.scan(CLASS_REGEX).join(' ')
          hash.merge!(parse_string_to_hash(str.gsub(/(?:\w+:\s*)#{DATA_ATTRIBUTES_VALUES_REGEX}/, '')))
          hash.merge!(parse_attr_to_hash(str[DATA_ATTRIBUTES_REGEX], 'data'))
          hash.merge!(parse_attr_to_hash(str[ARIA_ATTRIBUTES_REGEX], 'aria'))
          hash.reject { |_key, value| !value.present? }
        rescue
          raise SyntaxError, "HTML Attributes Syntax Error in the {: #{ str} :} above the #{@start_line}"
        end
      end

      private

      def parse_static_hash(text)
        attributes = {}
        return attributes if text.empty?

        text = text[1...-1] # strip brackets

        scanner = StringScanner.new(text)
        scanner.scan(/\s+/)
        until scanner.eos?
          return unless key = scanner.scan(ATTRIBUTES_KEY_REGEX)
          return unless scanner.scan(/\s*:\s*/)
          return unless value = scanner.scan(ATTRIBUTES_VALUES_REGEX)
          return unless scanner.scan(/\s*(?:,|$)\s*/)
          attributes[key.to_s] = value.gsub!(/'/, '').to_s
        end
        attributes
      end

      def parse_string_to_hash(text)
        text.scan(/(\w+:\s*)('(?:(?!').)*')/)
            .reduce({}) do |acc, (k, v)|
          acc.merge(k.gsub!(/#{INVALID_ATTRIBUTE_NAME_REGEX}|:/, '').to_sym => v.gsub!(/'/, '').to_s)
        end
      end

      def parse_attr_to_hash(str, name)
        return {} unless str.present?

        raise SyntaxError, "HTML Attributes Syntax Error.\nRedundant brackets in the #{str} \
                            above the #{@start_line} line" if str.scan(/{/).size != str.scan(/}/).size

        str.scan(DATA_ATTRIBUTES_VALUES_REGEX)
            .reduce({}) { |acc, elem| acc.merge(parse_static_hash(elem)) }
            .reduce({}) { |acc, (k, v)| acc.merge(name + '-' + k => v) }
      end
    end
  end
end
