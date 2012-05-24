require 'alchemist/conversion_table'
require 'alchemist/compound_numeric_conversion'
require 'alchemist/numeric_conversion'
require 'alchemist/numeric_ext'
require 'alchemist/unit_prefixes'

module Alchemist
  Conversions = {}

  @use_si = false
  class << self
    attr_accessor :use_si
  end
  
  @@si_units = %w[m meter metre meters metres liter litre litres liters l L farad farads F coulombs C gray grays Gy siemen siemens S mhos mho ohm ohms volt volts V ]
  @@si_units += %w[joule joules J newton newtons N lux lx henry henrys H b B bits bytes bit byte lumen lumens lm candela candelas cd]
  @@si_units += %w[tesla teslas T gauss Gs G gram gramme grams grammes g watt watts W pascal pascals Pa]
  @@si_units += %w[becquerel becquerels Bq curie curies Ci]
  
  def self.unit_prefixes
    @@unit_prefixes ||= UnitPrefixes.default
  end
  
  def self.conversion_table
    @@conversion_table ||= ConversionTable.default
  end
  
  def self.operator_actions
    @@operator_actions ||= {}
  end
  
  conversion_table.each do |type, conversions|
    conversions.each do |name, value|
      Conversions[name] ||= []
      Conversions[name] << type
    end
  end
  
  def self.register(type, names, value)
    names = [names] unless names.is_a?(Array)
    value = value.is_a?(NumericConversion) ? value.base(type) : value
    Alchemist.conversion_table[type] ||= {}
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
      if unit.to_s =~ /^#{prefix}.+/ && @@si_units.include?(unit.to_s.gsub(/^#{prefix}/,''))        
        if !(Conversions[ unit.to_s.gsub(/^#{prefix}/,'').to_sym ] & [ :information_storage ]).empty? && !@use_si && value >= 1000.0 && value.to_i & -value.to_i != value
          value = 2 ** (10 * (Math.log(value) / Math.log(10)) / 3)
        end
        return [value, unit.to_s.gsub(/^#{prefix}/,'').to_sym]
      end
    end
    [1.0, unit]
  end
end

class Numeric
  include Alchemist::NumericExt
end

require 'alchemist/compound'
