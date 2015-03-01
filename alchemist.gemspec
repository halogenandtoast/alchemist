# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alchemist/version'

Gem::Specification.new do |gem|
  gem.name = 'alchemist'
  gem.version = Alchemist::VERSION
  gem.authors = ["Matthew Mongeau"]
  gem.email = ["halogenandtoast@gmail.com"]
  gem.homepage = 'http://github.com/halogenandtoast/alchemist'
  gem.summary = 'A scientific conversion library'
  gem.description = 'A scientific conversion library'
  gem.license = 'MIT'

  gem.files = `git ls-files`.split($/)
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
end
