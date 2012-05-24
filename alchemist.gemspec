# -*- encoding: utf-8 -*-
PKG_FILES = %w(Rakefile) +
  Dir.glob("{lib}/**/*")

gem_spec = Gem::Specification.new do |gem_spec|
  gem_spec.name = 'alchemist'
  gem_spec.version = '0.1.3'
  gem_spec.summary = 'Conversions... like you\'ve never seen them before!'
  gem_spec.description = 'Conversions... like you\'ve never seen them before!!'
  gem_spec.email = 'halogenandtoast@gmail.com'
  gem_spec.homepage = 'http://github.com/halogenandtoast/alchemist'
  gem_spec.authors = ["Matthew Mongeau"]
  gem_spec.files = PKG_FILES
end
