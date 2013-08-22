require "alchemist/conversion_table"
require "alchemist/measurement"
require "alchemist/compound_measurement"
require "alchemist/module_builder"

# This is the main Alchemist module. It's purpose is to load and register unit
# categories and types.
module Alchemist
  autoload :Earth, "alchemist/objects/planets/earth"

  DATA_DIR = File.join(File.dirname(__FILE__), "alchemist", "data")

  DEFAULT_UNITS_FILE = File.join(DATA_DIR, "units.yml")
  DEFAULT_BINARY_PREFIXES_FILE = File.join(DATA_DIR, "binary_prefixes.yml")
  DEFAULT_SI_UNITS_FILE = File.join(DATA_DIR, "si_units.yml")
  DEFAULT_UNIT_PREFIXES_FILE = File.join(DATA_DIR, "unit_prefixes.yml")

  # Loads a `category` of measurements into Numeric as a module.
  #
  # If no `category` is provided, it will load all known categories:
  #
  # ```ruby
  # Alchemist.setup # loads all categories
  # Alchemist.setup(:distance) #loads only the distance category
  # ```
  def self.setup category = nil
    if category
      Numeric.send(:include, ModuleBuilder.new(category).build)
    else
      conversion_table.keys.each { |category| Numeric.send(:include, ModuleBuilder.new(category).build) }
    end
  end

  def self.measure value, unit, exponent = 1.0
    Measurement.new value, unit, exponent
  end

  def self.has_measurement? name
    conversions.keys.include? name.to_sym
  end

  def self.measurement_for name
    conversions[ name.to_sym ]
  end

  def self.register(type, names, value)
    names = Array(names)
    value = value.is_a?(Measurement) ? value.base(type) : value
    Alchemist.conversion_table[type] ||= {}

    names.each do |name|
      conversions[name] ||= []
      conversions[name] << type
      Alchemist.conversion_table[type][name] = value
    end
  end

  def self.parse_prefix(unit)
    matches = unit.to_s.match(prefix_matcher)
    prefix, parsed_unit = matches.captures

    if prefix && si_units.include?(parsed_unit)
      value = prefixed_value_for(prefix.to_sym, parsed_unit)
      [value, parsed_unit.to_sym]
    else
      [1, unit]
    end
  end

  def self.register_operation_conversions type, other_type, operation, converted_type
    operator_actions[operation] ||= []
    operator_actions[operation] << [type, other_type, converted_type]
  end

  def self.operator_actions
    @operator_actions ||= {}
  end

  def self.binary_prefixes
    @binary_prefixes ||= YAML.load_file(DEFAULT_BINARY_PREFIXES_FILE)
  end

  def self.si_units
    @si_units ||= YAML.load_file(DEFAULT_SI_UNITS_FILE)
  end

  def self.unit_prefixes
    @unit_prefixes ||= YAML.load_file(DEFAULT_UNIT_PREFIXES_FILE)
  end

  def self.use_si
    @use_si ||= false
  end

  def self.use_si= use_si
    @use_si = use_si
  end

  def self.load_conversion_table(filename=DEFAULT_UNITS_FILE)
    @conversion_table = ConversionTable.new.load_all(filename)
  end

  def self.conversion_table
    @conversion_table ||= load_conversion_table
  end

  def self.conversions
    @conversions ||= load_conversions
  end


  private

  def self.use_binary_prefix? unit
    !use_si && measurement_for(unit).include?(:information_storage)
  end

  def self.prefix_matcher
    @prefix_matcher ||= begin
                          prefix_keys = unit_prefixes.keys.map(&:to_s).sort{ |a,b| b.length <=> a.length }
                          %r{^(#{prefix_keys.join('|')})?(.+)}
                        end
  end

  def self.prefixed_value_for prefix, unit
    if use_binary_prefix? unit
      binary_prefixes[prefix]
    else
      unit_prefixes[prefix]
    end
  end

  def self.load_conversions
    conversions = {}
    conversion_table.each do |type, table_conversions|
      table_conversions.each do |name, value|
        conversions[name] ||= []
        conversions[name] << type
      end
    end
    conversions
  end
end
