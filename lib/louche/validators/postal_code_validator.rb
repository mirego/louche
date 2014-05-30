class PostalCodeValidator < Louche::RegexValidator
  message(:invalid_postal_code)
  regex(/\A[a-z]\d[a-z]\d[a-z]\d\z/i)
  cleanup_regex(/[^a-z0-9]/i)
end
