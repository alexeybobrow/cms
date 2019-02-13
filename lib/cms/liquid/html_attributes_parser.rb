# Parse html attributes
# Example:
#   "{: .class.next__class.another--class, #id, style: "display: inline-block;", target: "_blank", rel: "nofollow", data: {content: "test", handler: 'toggle'}, aria: {labelledby: 'ch1Tab'} :}"
#
require 'strscan'

module Cms
  module Liquid
    class HtmlAttributesParser
      private_class_method :new

      class AttributesSyntaxError < StandardError
      end

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

      def self.transform(str = '')
        return {} if str.blank? || !str.is_a?(String)
        new(str).call
      end

      def initialize(str)
        @str = str
      end

      def call
        str = @str[BODY_REGEX]
        str.gsub!(/[‘’"“”]/, '\'')
        hash = {}

        if str.scan(/{/).size != str.scan(/}/).size
          raise AttributesSyntaxError, "HTML Attributes Syntax Error. Unbalanced brackets"
        end

        begin
          hash[:id] = str.scan(ID_REGEX).first
          hash[:class] = str.scan(CLASS_REGEX).join(' ')
          hash.merge!(parse_string_to_hash(str.gsub(/(?:\w+:\s*)#{DATA_ATTRIBUTES_VALUES_REGEX}/, '')))
          hash.merge!(parse_attr_to_hash(str[DATA_ATTRIBUTES_REGEX], 'data'))
          hash.merge!(parse_attr_to_hash(str[ARIA_ATTRIBUTES_REGEX], 'aria'))
          hash.reject { |_, v| !v.present? }
        rescue AttributesSyntaxError => e
          raise AttributesSyntaxError, 'HTML Attributes Syntax Error.' + e.message
        end
      end

      private

      def parse_static_hash(text, name = nil)
        attributes = {}
        return attributes if text.empty?

        text = text[1...-1] # strip brackets

        scanner = StringScanner.new(text)
        scanner.scan(/\s+/)
        until scanner.eos?
          return unless key = scanner.scan(ATTRIBUTES_KEY_REGEX)
          key = "#{name}-#{key}" if name
          return unless scanner.scan(/\s*:\s*/)
          return unless value = scanner.scan(ATTRIBUTES_VALUES_REGEX)
          return unless scanner.scan(/\s*(?:,|$)\s*/)
          attributes[key.to_s] = value.gsub!(/'/, '').to_s
        end
        attributes
      end

      def parse_string_to_hash(text)
        text.scan(/(\w+):\s*'((?:(?!').)*)'/).to_h.symbolize_keys
      end

      def parse_attr_to_hash(str, name)
        return {} unless str.present?
        raise AttributesSyntaxError if str.scan(/{/).size != str.scan(/}/).size

        str.match(DATA_ATTRIBUTES_VALUES_REGEX) { |m| parse_static_hash(m[0], name) }
      end
    end
  end
end
