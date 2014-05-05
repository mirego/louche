class ArrayValidator < ActiveModel::EachValidator
  def initialize(options)
    options.reverse_merge!(message: :invalid_array)
    options.reverse_merge!(validity_method: :valid?)
    super
  end

  def validate_each(record, attribute, value)
    if value.is_a?(Array)
      validity_method = options.fetch(:validity_method)
      add_error(record, attribute, value) if value.empty? || !value.map.all?(&validity_method)
    else
      add_error(record, attribute, value)
    end
  end

  def add_error(record, attribute, value)
    record.errors.add(attribute, options.fetch(:message), value: value)
  end
end
