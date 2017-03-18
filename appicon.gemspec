# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'appicon/version'

Gem::Specification.new do |spec|
  spec.name          = "appicon"
  spec.version       = Appicon::VERSION
  spec.authors       = ["Erik Sundin"]
  spec.email         = ["erik@eriksundin.se"]
  spec.summary       = %q{Convert and install iOS App icons into an XCode Asset Catalog.}
  spec.homepage      = "https://github.com/eriksundin/appicon"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "commander"
  spec.add_dependency "json"
end
