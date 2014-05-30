module Louche
  class RegexValidator < ActiveModel::EachValidator
    def initialize(options)
      options.reverse_merge! message: self.class.message
      options.reverse_merge! regex: self.class.regex
      options.reverse_merge! cleanup_regex: self.class.cleanup_regex

      super
    end

    def validate_each(record, attribute, value)
      value = self.class.format_value(value, options.fetch(:cleanup_regex))
      record.send(:"#{attribute}=", value)

      unless value =~ options.fetch(:regex)
        record.errors.add(attribute, options.fetch(:message), value: value)
      end
    end

    def self.format_value(value, regex)
      value.try(:gsub, regex, '')
    end

    def self.message(value = nil)
      @message = value ? value : @message
    end

    def self.regex(value = nil)
      @regex = value ? value : @regex
    end

    def self.cleanup_regex(value = nil)
      @cleanup_regex = value ? value : @cleanup_regex
    end
  end
end
