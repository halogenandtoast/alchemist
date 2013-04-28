$:.unshift(File.dirname(__FILE__) + '../lib')

require 'test/unit'
require 'alchemist'

class AlchemistLoadCustomFileTest < Test::Unit::TestCase

  def setup
    load_custom
  end

  def teardown
    load_default
  end

  def load_custom
    Alchemist::load_conversion_table(
      File.join(File.dirname(__FILE__),"good_test.yml"))
  end

  def load_default
    Alchemist::load_conversion_table(
      File.join(File.dirname(__FILE__),"../lib/alchemist/units.yml"))
  end


  def test_load_file
    load_custom
    assert_not_nil(
      Alchemist::conversion_table, 
      "Should be able to load a valid yaml file")

    assert_equal(
      false,
      Alchemist::load_conversion_table(File.join(File.dirname(__FILE__),"bad_filename_test.yml")),
      "Should not load invalid yaml file")

    assert_equal(
      false,
      Alchemist::load_conversion_table(File.join(File.dirname(__FILE__),"bad_test.yml")),
      "Should not load invalid yaml file")
  end

  def test_loaded_correctly
    load_custom
    assert_equal( 
                 { goat: 1.0, dog: 5.6 }, 
                 Alchemist::conversion_table[:cow], 
                 "Did not load custom conversions correctly")

    assert_equal( 
                 { litre: 1.0, swallow: 0.006, pint: 0.5506105 }, 
                 Alchemist::conversion_table[:volume], 
                 "Possible loading/appending of extra conversions")
  end

end
