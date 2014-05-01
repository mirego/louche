class URLValidator < ActiveModel::EachValidator
  def initialize(options)
    options.reverse_merge!(schemes: %w(http https))
    options.reverse_merge!(message: :invalid_url)
    super
  end

  def validate_each(record, attribute, value)
    unless self.class.valid_url?(value, options)
      record.errors.add(attribute, options.fetch(:message), value: value)
    end
  end

  def self.valid_url?(url, options)
    schemes = [*options.fetch(:schemes)].map(&:to_s)

    if URI::regexp(schemes).match(url)
      begin
        URI.parse(url)
      rescue URI::InvalidURIError
        false
      end
    else
      false
    end
  end
end
