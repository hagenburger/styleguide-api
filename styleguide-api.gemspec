# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "styleguide-api/version"

Gem::Specification.new do |spec|
  spec.name          = "styleguide-api"
  spec.version       = StyleGuideAPI::VERSION
  spec.authors       = ["Nico Hagenburger"]
  spec.email         = ["nico@hagenburger.net"]
  spec.summary       = %q{Helpers for creating a style guide API}
  spec.description   = %q{Helpers for a style guide API provider and consumer with Tilt templates}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
