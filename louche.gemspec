# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'louche/version'

Gem::Specification.new do |spec|
  spec.name          = 'louche'
  spec.version       = Louche::VERSION
  spec.authors       = ['Rémi Prévost']
  spec.email         = ['rprevost@mirego.com']
  spec.summary       = 'Louche provides common validators for ActiveModel/ActiveRecord classes'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/mirego/louche'
  spec.license       = 'BSD-3 Clause'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activemodel', '>= 4.0.0'

  spec.add_development_dependency 'rspec', '~> 3.0.0.beta2'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop', '0.22'
  spec.add_development_dependency 'phare'
end
