class PostalCodeValidator < ActiveModel::EachValidator
  def initialize(options)
    options.reverse_merge!(message: :invalid_postal_code)
    options.reverse_merge!(regex: /^[a-z]\d[a-z]\d[a-z]\d$/i)
    super
  end

  def validate_each(record, attribute, value)
    value = PostalCodeValidator.format_code(value)
    record.send(:"#{attribute}=", value)

    unless value =~ options.fetch(:regex)
      record.errors.add(attribute, options.fetch(:message), value: value)
    end
  end

  def self.format_code(postal_code)
    postal_code.try(:gsub, /[^a-z0-9]/i, '')
  end
end
