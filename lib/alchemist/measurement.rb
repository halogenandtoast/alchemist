require "bigdecimal"
require "alchemist/measurement_convertor"

module Alchemist
  class Measurement
    include Comparable

    attr_reader :unprefixed_unit_name, :exponent, :value, :prefix

    def initialize value, unit_name, exponent = 1.0, options = {}
      @value = value.to_f
      @unprefixed_unit_name = unit_name.to_sym
      @exponent = exponent
      @prefix = options[:prefix] || ""
    end

    def unit_name
      "#{prefix}#{unprefixed_unit_name}"
    end

    def per
      CompoundMeasurement.new self
    end

    def to type = nil
      if type
        convertor.send(type, exponent)
      else
        convertor
      end
    end

    def + measurement
      ensure_shared_type!(measurement)
      converted = measurement.to(unit_name)
      addend = converted.value / exponent
      remeasure(value + addend)
    end

    def - measurement
      ensure_shared_type!(measurement)
      converted = measurement.to(unit_name)
      subtrahend = converted.value / exponent
      remeasure(value - subtrahend)
    end

    def / measurement
      converted = remeasure(value / dividend(measurement))

      if measurement.is_a?(Measurement)
        converted.value
      else
        converted
      end
    end

    def * multiplicand
      if multiplicand.is_a?(Numeric)
        remeasure(value * multiplicand)
      else
        try_raising_dimension(multiplicand)
      end
    end

    def base unit_type
      conversion_base = conversion_base_for(unit_type)
      convert_to_base(conversion_base)
    end

    def to_s
      to_f.to_s
    end

    def to_i
      to_f.to_i
    end

    def to_f
      (precise_value * exponent).to_f
    end

    def <=> other
      to_f <=> other.to(unit_name).to_f
    end

    def == other
      to_f <=> other.to(unit_name).to_f
    end

    def types
      library.measurement_for(unprefixed_unit_name)
    end

    def shared_types other_unit_name
      types & library.measurement_for(other_unit_name)
    end

    def coerce(number)
      [self, number]
    end

    def round(*args)
      remeasure(value.round(*args))
    end

    def ceil(*args)
      remeasure(value.ceil(*args))
    end

    def floor(*args)
      remeasure(value.floor(*args))
    end

    private

    def dividend measurement
      if measurement.is_a?(Measurement)
        ensure_shared_type!(measurement)
        measurement.to(unit_name).to_f / exponent
      else
        measurement
      end
    end

    def remeasure value
      Measurement.new(value, unit_name, exponent)
    end

    def library
      Alchemist.library
    end

    def ensure_shared_type! measurement
      if !has_shared_types?(measurement.unprefixed_unit_name)
        incompatible_type_error
      end
    end

    def convert_to_base conversion_base
      if conversion_base.is_a?(Array)
        exponent * conversion_base.first.call(value)
      else
        precise_value * conversion_base * exponent
      end
    end

    def conversion_base_for unit_type
      library.conversion_base_for(unit_type, unprefixed_unit_name)
    end

    def has_shared_types? other_unit_name
      shared_types(other_unit_name).length > 0
    end

    def try_raising_dimension(measurement)
      valid_types = shared_types(measurement.unit_name)
      library.operator_actions[:*].each do |s1, s2, new_type|
        if (valid_types & [s1, s2]).any?
          return Alchemist.measure(value * measurement.to_f, new_type)
        end
      end
      incompatible_type_error
    end

    def convertor
      MeasurementConvertor.new(self)
    end

    def precise_value
      BigDecimal.new(@value.to_s)
    end

    private

    def incompatible_type_error
      raise IncompatibleTypeError, "Incompatible Types"
    end
  end
end
