require 'rake'
require 'rake/testtask'
 
PKG_FILES = %w(Rakefile) +
      Dir.glob("{lib}/**/*")
       
gem_spec = Gem::Specification.new do |gem_spec|
  gem_spec.name = 'alchemist'
  gem_spec.version = '0.0.6'
  gem_spec.summary = 'Conversions... like you\'ve never seen them before!'
  gem_spec.description = 'Conversions... like you\'ve never seen them before!!'
  gem_spec.email = 'matt@toastyapps.com'
  gem_spec.homepage = 'http://github.com/toastyapps/alchemist'
  gem_spec.authors = ["Matthew Mongeau"]
  gem_spec.files = PKG_FILES
end
 
desc "Generate a gemspec file"
task :gemspec do
  File.open("#{gem_spec.name}.gemspec", "w") do |f|
    f.write gem_spec.to_yaml
  end
end