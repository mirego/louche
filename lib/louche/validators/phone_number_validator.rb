class PhoneNumberValidator < ActiveModel::EachValidator
  def initialize(options)
    options.reverse_merge!(message: :invalid_phone_number)
    options.reverse_merge!(regex: /\d{10,}/)
    super
  end

  def validate_each(record, attribute, value)
    value = PhoneNumberValidator.format_number(value)
    record.send(:"#{attribute}=", value)

    unless value =~ options.fetch(:regex)
      record.errors.add(attribute, options.fetch(:message), value: value)
    end
  end

  def self.format_number(number)
    number.try(:gsub, /[^\d]/, '')
  end
end
