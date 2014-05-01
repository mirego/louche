class ArrayValidator < ActiveModel::EachValidator
  def initialize(options)
    options.reverse_merge!(message: :invalid_array)
    super
  end

  def validate_each(record, attribute, value)
    if value.is_a?(Array)
      add_error(record, attribute, value) if value.empty? || !value.map.all?(&:valid?)
    else
      add_error(record, attribute, value)
    end
  end

  def add_error(record, attribute, value)
    record.errors.add(attribute, options.fetch(:message), value: value)
  end
end
