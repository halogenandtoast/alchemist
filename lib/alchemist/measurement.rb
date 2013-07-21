require "alchemist/measurement_convertor"

module Alchemist
  class Measurement
    include Comparable

    attr_reader :unit_name, :exponent, :value

    def initialize value, unit_name, exponent = 1.0
      @value = value.to_f
      @unit_name = unit_name
      @exponent = exponent
    end

    def to type = nil
      if type
        convertor.send(type)
      else
        convertor
      end
    end

    def + measurement
      ensure_shared_type!(measurement)
      Measurement.new(value + measurement.value, unit_name, exponent)
    end

    def - measurement
      ensure_shared_type!(measurement)
      Measurement.new(value - measurement.value, unit_name, exponent)
    end

    def / dividend
      Measurement.new(value / dividend, unit_name, exponent)
    end

    def * multiplicand
      Measurement.new(value * multiplicand, unit_name, exponent)
    end

    def base unit_type
      conversion_base = conversion_base_for(unit_type)
      convert_to_base conversion_base
    end

    def to_s
      value.to_s
    end

    def to_i
      value.to_i
    end

    def to_f
      @value
    end

    def <=>(other)
      (self.to_f * exponent).to_f <=> other.to(unit_name).to_f
    end

    def types
      Alchemist.measurement_for(unit_name)
    end

    def shared_types other_unit_name
      types & Alchemist.measurement_for(other_unit_name)
    end

    private

    def ensure_shared_type! measurement
      incompatible_types unless has_shared_types?(measurement.unit_name)
    end

    def convert_to_base conversion_base
      if conversion_base.is_a?(Array)
        exponent * conversion_base[0].call(value)
      else
        exponent * value * conversion_base
      end
    end

    def conversion_base_for unit_type
      Alchemist.conversion_table[unit_type][unit_name]
    end

    def has_shared_types? other_unit_name
      shared_types(other_unit_name).length > 0
    end

    def incompatible_types
      raise Exception, "Incompatible Types"
    end

    def convertor
      MeasurementConvertor.new(self)
    end
  end
end
