require "alchemist/conversion_table"
require "alchemist/compound_numeric_conversion"
require "alchemist/numeric_conversion"
require "alchemist/numeric_ext"

module Alchemist
  DATA_DIR = File.join(File.dirname(__FILE__), "alchemist", "data")

  DEFAULT_UNITS_FILE = File.join(DATA_DIR, "units.yml")
  DEFAULT_BINARY_PREFIXES_FILE = File.join(DATA_DIR, "binary_prefixes.yml")
  DEFAULT_SI_UNITS_FILE = File.join(DATA_DIR, "si_units.yml")
  DEFAULT_UNIT_PREFIXES_FILE = File.join(DATA_DIR, "unit_prefixes.yml")

  def self.measurement value, unit, exponent = 1.0
    NumericConversion.new value, unit, exponent
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

  def self.measurement_for name
    conversions[ name.to_sym ]
  end

  def self.register(type, names, value)

    names = Array(names)
    value = value.is_a?(NumericConversion) ? value.base(type) : value
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

  private

  def self.use_binary_prefix? unit
    !use_si && measurement_for(unit).include?(:information_storage)
  end

  def self.prefix_matcher
    keys = unit_prefixes.keys.map(&:to_s).sort{ |a,b| b.length <=> a.length }
    %r{^(#{keys.join('|')})?(.+)}
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
