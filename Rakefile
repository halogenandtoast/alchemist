require 'bundler/gem_tasks'
require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task default: :spec

task :cov do
  ENV["COVERAGE"] = "true"
  Rake::Task[:spec].execute
end
