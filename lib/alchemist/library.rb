require 'singleton'

module Alchemist
  def self.library
    Library.instance
  end

  class Library
    include Singleton

    attr_reader :si_units, :unit_prefixes, :conversion_table

    def initialize
      @conversion_table = load_conversion_table
      @si_units = YAML.load_file(Configuration::DEFAULT_SI_UNITS_FILE)
      @unit_prefixes = YAML.load_file(Configuration::DEFAULT_UNIT_PREFIXES_FILE)
      @binary_prefixes = YAML.load_file(Configuration::DEFAULT_BINARY_PREFIXES_FILE)
    end

    def categories
      @conversion_table.keys
    end

    def unit_names category
      @conversion_table[category.to_sym].map { |values| values[0] }
    end

    def measurement_for unit_name
      conversions[ unit_name.to_sym ]
    end

    def conversions
      @conversions ||= load_conversions
    end

    def conversion_base_for(unit_type, unit_name)
      @conversion_table[unit_type][unit_name]
    end

    def has_measurement? name
      conversions.keys.include? name.to_sym
    end

    def register_operation_conversions type, other_type, operation, converted_type
      operator_actions[operation] ||= []
      operator_actions[operation] << [type, other_type, converted_type]
    end

    def operator_actions
      @operator_actions ||= {}
    end

    def load_conversion_table(filename=Configuration::DEFAULT_UNITS_FILE)
      if new_table = ConversionTable.new.load_all(filename)
        @conversion_table = new_table
      else
        @conversion_table ||= load_conversion_table
      end
    end

    def register(type, names, value)
      names = Array(names)
      value = value.is_a?(Measurement) ? value.base(type) : value
      conversion_table[type] ||= {}

      names.each do |name|
        conversions[name] ||= []
        conversions[name] << type
        conversion_table[type][name] = value
      end
    end

    private

    def load_conversions
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
end
