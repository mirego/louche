class PostalCodeValidator < ActiveModel::EachValidator
  def initialize(options)
    options.reverse_merge!(message: :invalid_postal_code)
    options.reverse_merge!(regex: /\A[a-z]\d[a-z]\d[a-z]\d\z/i)
    options.reverse_merge!(cleanup_regex: /[^a-z0-9]/i)
    super
  end

  def validate_each(record, attribute, value)
    value = PostalCodeValidator.format_code(value, options.fetch(:cleanup_regex))
    record.send(:"#{attribute}=", value)

    unless value =~ options.fetch(:regex)
      record.errors.add(attribute, options.fetch(:message), value: value)
    end
  end

  def self.format_code(postal_code, regex)
    postal_code.try(:gsub, regex, '')
  end
end
