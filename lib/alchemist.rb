require "alchemist/conversion_table"
require "alchemist/measurement"
require "alchemist/compound_measurement"
require "alchemist/module_builder"
require "alchemist/configuration"
require "alchemist/library"

module Alchemist
  autoload :Earth, "alchemist/objects/planets/earth"

  def self.setup category = nil
    if category
      Numeric.send(:include, ModuleBuilder.new(category).build)
    else
      library.categories.each { |category| Numeric.send(:include, ModuleBuilder.new(category).build) }
    end
  end

  def self.measure value, unit, exponent = 1.0
    Measurement.new value, unit, exponent
  end
end
