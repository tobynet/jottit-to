# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jottit/to/version'

Gem::Specification.new do |spec|
  spec.name          = "jottit-to"
  spec.version       = Jottit::To::VERSION
  spec.authors       = ["toooooooby"]
  spec.email         = ["toby.net.info.mail+git@gmail.com"]
  spec.summary       = %q{Jottit list page converter CLI}
  spec.description   = %q{a tool for converting a list in jottit page to any formats}
  spec.homepage      = "https://github.com/toooooooby/jottit-to"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
