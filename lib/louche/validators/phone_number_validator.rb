class PhoneNumberValidator < Louche::RegexValidator
  message(:invalid_phone_number)
  regex(/\A\d{10,}\z/)
  cleanup_regex(/[^\d]/)
end
