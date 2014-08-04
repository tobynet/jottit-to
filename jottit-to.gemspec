# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jottit/version'

Gem::Specification.new do |spec|
  spec.name          = "jottit-to"
  spec.version       = JottitTo::VERSION
  spec.authors       = ["tobynet"]
  spec.email         = ["toby.net.info.mail+git@gmail.com"]
  spec.summary       = %q{Jottit list page converter CLI}
  spec.description   = %q{A tool for converting a list in jottit page to any formats}
  spec.homepage      = "https://github.com/tobynet/jottit-to"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'nokogiri', '~> 1.6'
  spec.add_dependency 'builder', '~> 3.2'
  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.2'
  spec.add_development_dependency 'webmock', '~> 1.17'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'minitest', '~> 5.4'
end
