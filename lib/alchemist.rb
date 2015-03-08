require "alchemist/conversion_table"
require "alchemist/measurement"
require "alchemist/compound_measurement"
require "alchemist/module_builder"
require "alchemist/configuration"
require "alchemist/library"
require "alchemist/conversion_calculator"

module Alchemist

  autoload :Earth, "alchemist/objects/planets/earth"

  class IncompatibleTypeError < StandardError ; end
  class GeospatialArgumentError < StandardError ; end

  def self.setup category = nil
    if category
      load_category category
    else
      load_all_categories
    end
  end

  def self.measure value, unit, exponent = 1.0
    Measurement.new value, unit, exponent
  end

  def self.measure_prefixed value, prefix, unit
    exponent = library.exponent_for(unit, prefix)
    Measurement.new value, unit, exponent, prefix: prefix
  end

  def self.library
    @library ||= Library.new
  end

  def self.config
    @configuration ||= Configuration.new
  end

  def self.register(types, names, value)
    library.register(types, names, value)
  end

  def self.reset!
    @library = nil
    @configuration = nil
  end

  private

  def self.load_all_categories
    library.load_all_categories
  end

  def self.load_category category
    library.load_category(category)
  end
end
