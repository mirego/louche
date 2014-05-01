class PhoneNumberValidator < ActiveModel::EachValidator
  def initialize(options)
    options.reverse_merge!(message: :invalid_phone_number)
    options.reverse_merge!(regex: /\d{10,}/)
    options.reverse_merge!(cleanup_regex: /[^\d]/)
    super
  end

  def validate_each(record, attribute, value)
    value = PhoneNumberValidator.format_number(value, options.fetch(:cleanup_regex))
    record.send(:"#{attribute}=", value)

    unless value =~ options.fetch(:regex)
      record.errors.add(attribute, options.fetch(:message), value: value)
    end
  end

  def self.format_number(number, regex)
    number.try(:gsub, regex, '')
  end
end
