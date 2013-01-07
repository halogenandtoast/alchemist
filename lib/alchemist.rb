require "alchemist/units"
require "alchemist/compound_numeric_conversion"
require "alchemist/numeric_conversion"
require "alchemist/numeric_ext"

module Alchemist
  Conversions = {}

  def from(unit_name)
    send(unit_name.to_sym)
  end

  def method_missing unit_name, *args, &block
    exponent, unit_name = Alchemist.parse_prefix(unit_name)
    Conversions[ unit_name ] || super( unit_name, *args, &block )
    NumericConversion.new self, unit_name, exponent
  end

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
    unit_prefixes.each do |prefix, value|
      if unit.to_s =~ /^#{prefix}.+/ && si_units.include?(unit.to_s.gsub(/^#{prefix}/,''))
        if !(Conversions[ unit.to_s.gsub(/^#{prefix}/,'').to_sym ] & [ :information_storage ]).empty? && !use_si && value >= 1e3 && power_of_2?(value)
          value = convert_to_binary(value)
        end
        return [value, unit.to_s.gsub(/^#{prefix}/,'').to_sym]
      end
    end
    [1.0, unit]
  end

  def self.power_of_2? value
    value.to_i & -value.to_i != value
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
