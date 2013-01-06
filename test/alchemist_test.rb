$:.unshift(File.dirname(__FILE__) + '../lib')

require 'test/unit'
require 'alchemist'

class Float
  # truncates float to specified decimal places
  def truncate(dec = 0)
    return to_i if dec == 0
    sprintf("%.#{dec}f", self).to_f
  end
end

class AlchemistTest < Test::Unit::TestCase

  def test_equivalence
    assert_equal(1.m, 1.meter)
  end

  def test_bit_and_bytes
    assert_equal( 65.bit.to_f,  (1.bit + 8.bytes).to_f )
    assert_equal( 0.125.bytes.to_f, 1.bit.to.bytes.to_f )
    assert_in_delta(1.MB.to.kB.to_f, 1024.0, 1e-5)
    assert_in_delta(1.MB.to.b.to_f, 8388608.0, 1e-5)
    assert_in_delta(1.GB.to.B.to_f, 1073741824.0, 1e-5)
    assert_in_delta(1.MiB.to.KiB.to_f, 1024.0, 1e-5)
    assert_in_delta(1.MiB.to.b.to_f, 8388608.0, 1e-5)
    assert_in_delta(1.GiB.to.B.to_f, 1073741824.0, 1e-5)
    Alchemist::use_si = true
    assert_in_delta(1.GB.to.B.to_f, 1000000000.0, 1e-5)
    assert_in_delta(1.MB.to.b.to_f, 8000000.0, 1e-5)
    assert_in_delta(1.MB.to.kB.to_f, 1000.0, 1e-5)
  end

  def test_feet_to_miles
    assert_equal( 5280.feet,  1.mile.to.feet )
  end

  def test_acre_to_yards_squared
    assert_in_delta( 4840.square_yards.to_f,  1.acre.to.square_yards.to_f, 1e-5)
  end

  def test_gallon_to_liter
    assert_in_delta( 3.785411784.L.to_f, 1.gallon.to.L.to_f, 1e-5 )
  end

  def test_lb_to_kg
    assert_equal( 0.45359237.kg.to_f, 1.lb.to.kg.to_f )
  end

  def test_comparison
    assert_equal( 5.grams, 0.005.kilograms )
  end

  def test_register
    Alchemist.register(:distance, [:beard_second, :beard_seconds], 5.angstroms)
    assert_equal( 1.beard_second, 5.angstroms)
    Alchemist.register(:temperature, :yeti, [Proc.new{|t| t + 1}, Proc.new{|t| t - 1}])
    assert_equal( 0.yeti, 1.kelvin)
  end

  def test_meters_times_meters
    assert_equal(1.meter * 1.meter, 1.square_meter)
  end

  def test_meters_times_meters_times_meters
    assert_equal(1.meter * 2.meter * 3.meter, 6.cubic_meters)
    assert_equal(2.square_meters * 3.meters, 6.cubic_meters)
  end

  def test_division
    assert_equal(2.meters / 1.meters, 2.0)
  end

  # Don't think these worked before
  # def test_temperature
  #   assert_equal(1.fahrenheit, 1.fahrenheit)
  #   assert_in_delta(1.fahrenheit, 1.fahrenheit.to.fahrenheit, 1e-5)
  # end

  def test_density
    assert_equal(25.brix.to_f, 1.1058.sg.to.brix.truncate(1))
    assert_equal(25.plato, 25.125.brix)
  end

  def test_frequency
    assert_equal(1.hertz, 60.rpm)
    assert_equal(60.hz, 3600.rpm)
    assert_equal(2400.rpm, 40.hz)
  end
end
