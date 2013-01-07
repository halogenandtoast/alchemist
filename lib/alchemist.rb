require "alchemist/units"
require "alchemist/compound_numeric_conversion"
require "alchemist/numeric_conversion"
require "alchemist/numeric_ext"

module Alchemist
  Conversions = {}

  def self.use_si
    @use_si ||= false
  end

  def self.use_si= use_si
    @use_si = use_si
  end

  def self.unit_prefixes
    @@unit_prefixes
  end

  def self.conversion_table
    @@conversion_table
  end

  def self.operator_actions
    @@operator_actions ||= {}
  end

  def self.si_units
    @@si_units
  end

  def self.register(type, names, value)

    names = Array(names)
    value = value.is_a?(NumericConversion) ? value.base(type) : value

    names.each do |name|
      Conversions[name] ||= []
      Conversions[name] << type
      Alchemist.conversion_table[type][name] = value
    end
  end

  def self.register_operation_conversions type, other_type, operation, converted_type
    operator_actions[operation] ||= []
    operator_actions[operation] << [type, other_type, converted_type]
  end

  def self.parse_prefix(unit)
    unit = unit.to_s
    unit_prefixes.each do |prefix, value|
      if starts_with_prefix?(unit, prefix) && si_units.include?(remove_prefix(unit, prefix))
        unit = remove_prefix(unit, prefix).to_sym

        if !(Conversions[ unit ] & [ :information_storage ]).empty? && !use_si && value >= 1e3 && power_of_2?(value)
          value = convert_to_binary(value)
        end

        return [value, unit]
      end
    end
    [1.0, unit.to_sym]
  end

  def self.remove_prefix unit, prefix
    unit.gsub(/^#{prefix}/, '')
  end

  def self.power_of_2? value
    value.to_i & -value.to_i != value
  end

  def self.starts_with_prefix? unit, prefix
    unit.to_s =~ /^#{prefix}.+/
  end

  def self.convert_to_binary value
    exponent = Math.log10(value)
    2 ** (10 * (exponent / 3))
  end

  conversion_table.each do |type, conversions|
    conversions.each do |name, value|
      Conversions[name] ||= []
      Conversions[name] << type
    end
  end
end

require "alchemist/compound"
