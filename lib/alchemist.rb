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
      Numeric.send :include, ModuleBuilder.new(category).build
    else
      setup_all_categories
    end
  end

  def self.measure value, unit, exponent = 1.0
    Measurement.new value, unit, exponent
  end

  def self.library
    @@library ||= Library.new
  end

  def self.config
    @@configuration ||= Configuration.new
  end

  private

  def self.setup_all_categories
    library.categories.each do|category|
      Numeric.send :include, ModuleBuilder.new(category).build
    end
  end

end
