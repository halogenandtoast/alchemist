require "alchemist/units"
require "alchemist/compound_numeric_conversion"
require "alchemist/numeric_conversion"
require "alchemist/numeric_ext"

module Alchemist
  def self.use_si
    @use_si ||= false
  end

  def self.use_si= use_si
    @use_si = use_si
  end

  def self.use_binary? unit
    !use_si && measurement_for(unit).include?(:information_storage)
  end

  def self.unit_prefixes
    UNIT_PREFIXES
  end

  def self.binary_prefixes
    BINARY_PREFIXES
  end

  def self.conversion_table
    @conversion_table ||= CONVERSION_TABLE.dup
  end

  def self.operator_actions
    @operator_actions ||= {}
  end

  def self.si_units
    SI_UNITS
  end

  def self.conversions
    @conversions ||= {}
  end

  def self.measurement_for name
    conversions[ name.to_sym ]
  end

  def self.register(type, names, value)

    names = Array(names)
    value = value.is_a?(NumericConversion) ? value.base(type) : value

    names.each do |name|
      conversions[name] ||= []
      conversions[name] << type
      Alchemist.conversion_table[type][name] = value
    end
  end

  def self.register_operation_conversions type, other_type, operation, converted_type
    operator_actions[operation] ||= []
    operator_actions[operation] << [type, other_type, converted_type]
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

  def self.prefix_matcher
    keys = unit_prefixes.keys.map(&:to_s).sort{ |a,b| b.length <=> a.length }
    %r{^(#{keys.join('|')})?(.+)}
  end

  def self.prefixed_value_for prefix, unit
    if use_binary?(unit)
      binary_prefixes[prefix]
    else
      unit_prefixes[prefix]
    end
  end

  conversion_table.each do |type, table_conversions|
    table_conversions.each do |name, value|
      conversions[name] ||= []
      conversions[name] << type
    end
  end
end

require "alchemist/compound"
