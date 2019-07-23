# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gus_bir1/version'

Gem::Specification.new do |spec|
  spec.name          = 'gus_bir1'
  spec.version       = GusBir1::VERSION
  spec.authors       = ['Wacław Łuczak']
  spec.email         = ['waclaw@luczak.it']

  spec.summary       = 'Rails GUS API library based on official REGON SOAP api.'
  spec.homepage      = 'https://github.com/espago/gus_bir1'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.52'
  spec.add_development_dependency 'simplecov', '~> 0'

  spec.add_dependency 'savon', '~> 2.12'
  spec.add_dependency 'savon-multipart--feb-2019', '~> 2.1', '>= 2.1.2'
end
