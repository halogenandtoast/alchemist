$:.unshift(File.dirname(__FILE__) + '../lib')

require 'test/unit'
require 'alchemist'

class AlchemistMeasurementTest < Test::Unit::TestCase

  def test_measurement
    unit = Alchemist.measurement(1, :meter)
    assert_equal(unit, 1.meter)
  end

end
