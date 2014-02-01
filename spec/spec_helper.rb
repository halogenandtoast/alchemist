$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "..", "lib")

if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
end

require 'alchemist'
require 'alchemist/geospatial'

RSpec.configure do |config|
  config.before(:each) do
    Alchemist.reset!
  end
end

Alchemist.setup
