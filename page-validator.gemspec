# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'page/validator/version'

Gem::Specification.new do |spec|
  spec.name          = "page-validator"
  spec.version       = Page::Validator::VERSION
  spec.authors       = ["Vladimir Vladimirov"]
  spec.email         = ["vladimir@jwplayer.com"]
  spec.description   = %q{Page validation helpers for page-object based testing projects.}
  spec.summary       = %q{This is extension to page-object gem functionality.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "page-object"
end
