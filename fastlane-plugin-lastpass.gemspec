# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/lastpass/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-lastpass'
  spec.version       = Fastlane::Lastpass::VERSION
  spec.author        = 'Antoine Lamy'
  spec.email         = 'antoinelamy@gmail.com'

  spec.summary       = 'Easily sync your Apple ID credentials stored in LastPass with your keychain using CredentialManager'
  spec.homepage      = "https://github.com/antoinelamy/fastlane-plugin-lastpass"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'lastpass'

  spec.add_development_dependency('pry')
  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rubocop', '0.49.1')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('fastlane', '>= 2.95.0')
end
