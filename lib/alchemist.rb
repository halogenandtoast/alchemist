require "alchemist/conversion_table"
require "alchemist/compound_numeric_conversion"
require "alchemist/numeric_conversion"
require "alchemist/numeric_ext"

module Alchemist
  DEFAULT_YAML_FILE = File.join(File.dirname(__FILE__), "alchemist/units.yml")

  def self.measurement value, unit, exponent = 1.0
    NumericConversion.new value, unit, exponent
  end

  def self.use_si
    @use_si ||= false
  end

  def self.use_si= use_si
    @use_si = use_si
  end

  def self.load_conversion_table(filename=DEFAULT_YAML_FILE)
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
    {
      :yotta => 2.0**80.0, :Y => 2.0**80,
      :zetta => 2.0**70.0, :Z => 2.0**70.0,
      :exa => 2.0**60.0, :E => 2.0**60.0,
      :peta => 2.0**50.0, :P => 2.0**50.0,
      :tera => 2.0**40.0, :T => 2.0**40.0,
      :giga => 2.0**30.0, :G => 2.0**30.0,
      :mega => 2.0**20.0, :M => 2.0**20.0,
      :kilo => 2.0**10.0, :k => 2.0**10.0,

      # binary prefixes

      :kibi => 2.0**10.0, :Ki => 2.0**10.0,
      :mebi => 2.0**20.0, :Mi => 2.0**20.0,
      :gibi => 2.0**30.0, :Gi => 2.0**30.0,
      :tebi => 2.0**40.0, :Ti => 2.0**40.0,
      :pebi => 2.0**50.0, :Pi => 2.0**50.0,
      :exbi => 2.0**60.0, :Ei => 2.0**60.0,
      :zebi => 2.0**70.0, :Zi => 2.0**70.0,
      :yobi => 2.0**80.0, :Yi => 2.0**80.0
    }
  end

  def self.si_units
    %w[
      m meter metre meters metres liter litre litres liters l L
      farad farads F coulombs C gray grays Gy siemen siemens S
      mhos mho ohm ohms volt volts V joule joules J newton
      newtons N lux lx henry henrys H b B bits bytes bit byte
      lumen lumens lm candela candelas cd tesla teslas T gauss
      Gs G gram gramme grams grammes g watt watts W pascal
      pascals Pa becquerel becquerels Bq curie curies Ci
    ]
  end

  def self.unit_prefixes
    {
      :googol => 1e+100,
      :yotta => 1e+24, :Y => 1e+24,
      :zetta => 1e+21, :Z => 1e+21,
      :exa => 1e+18, :E => 1e+18,
      :peta => 1e+15, :P => 1e+15,
      :tera => 1e+12, :T => 1e+12,
      :giga => 1e+9, :G => 1e+9,
      :mega => 1e+6, :M => 1e+6,
      :kilo => 1e+3, :k => 1e+3,
      :hecto => 1e+2, :h => 1e+2,
      :deca => 10, :da => 10,
      :deci => 1e-1, :d => 1e-1,
      :centi => 1e-2, :c => 1e-2,
      :milli => 1e-3, :m => 1e-3,
      :micro => 1e-6, :u => 1e-6,
      :nano => 1e-9, :n => 1e-9,
      :pico => 1e-12, :p => 1e-12,
      :femto => 1e-15, :f => 1e-15,
      :atto => 1e-18, :a => 1e-18,
      :zepto => 1e-21, :z => 1e-21,
      :yocto => 1e-24, :y => 1e-24,

      # binary prefixes

      :kibi => 2.0**10.0, :Ki => 2.0**10.0,
      :mebi => 2.0**20.0, :Mi => 2.0**20.0,
      :gibi => 2.0**30.0, :Gi => 2.0**30.0,
      :tebi => 2.0**40.0, :Ti => 2.0**40.0,
      :pebi => 2.0**50.0, :Pi => 2.0**50.0,
      :exbi => 2.0**60.0, :Ei => 2.0**60.0,
      :zebi => 2.0**70.0, :Zi => 2.0**70.0,
      :yobi => 2.0**80.0, :Yi => 2.0**80.0
    }
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
