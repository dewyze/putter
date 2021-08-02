# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'putter/version'

Gem::Specification.new do |spec|
  spec.name          = "putter"
  spec.version       = Putter::VERSION
  spec.authors       = ["John DeWyze"]
  spec.email         = ["putter@dewyze.io"]

  spec.description   = "Putter provides a variety of methods to easily use puts debugging. It can reveal what methods are called, the arguments that were passed in, and what the result of the method call."
  spec.summary       = "Putter makes puts debugging easy."
  spec.homepage      = "https://github.com/dewyze/putter"
  spec.license       = "MIT"

  spec.required_ruby_version = '~> 2.7'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'colorize', '~> 0'

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "pry", "~> 0.14.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
