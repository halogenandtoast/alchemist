require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'

task :default => [:test]
task :test => ['test:units']

namespace :test do
  Rake::TestTask.new(:units) do |test|
    test.libs << 'test'
    test.ruby_opts << '-rubygems'
    test.pattern = 'test/*.rb'
    test.verbose = true
  end
end
