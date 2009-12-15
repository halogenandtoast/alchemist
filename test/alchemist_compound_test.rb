$:.unshift(File.dirname(__FILE__) + '../lib')

require 'test/unit'
require 'alchemist'

class AlchemistCompoundTest < Test::Unit::TestCase
  def test_compound
    assert_equal 30.miles, (10.miles.per.second * 3.seconds)
    assert_equal 30.km, (10.km.p.h * 3.hours)
    assert_equal 4, 4.m.per.m
  end
end