class RgbHexValidator < Louche::RegexValidator
  message(:invalid_rgb_hex)
  regex(/\A#([a-f0-9]{6}|[a-f0-9]{3})\z/i)
  cleanup_regex(/[^#a-f0-9]/i)
end
