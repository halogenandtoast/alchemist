$:.unshift(File.dirname(__FILE__) + '../lib')

require 'test/unit'
require 'alchemist'

class AlchemistCompoundTest < Test::Unit::TestCase
  def test_compound
    puts 1.mile
  end
end