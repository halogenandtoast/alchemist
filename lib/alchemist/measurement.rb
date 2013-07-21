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

    def per
      CompoundMeasurement.new self
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

    def / measurement
      ensure_shared_type!(measurement)
      dividend = measurement.is_a?(Measurement) ? measurement.to(unit_name).to_f / exponent : measurement
      Measurement.new(value / dividend, unit_name, exponent).value
    end

    def * multiplicand
      if wrap = check_for_conversion_wrap(:*, multiplicand)
        return wrap.value
      end
      if multiplicand.is_a?(Numeric)
        Measurement.new(value * multiplicand, unit_name, exponent)
      else
        raise Exception, "Incompatible Types"
      end
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

    def shared_types other_unit_name
      types & Alchemist.measurement_for(other_unit_name)
    end

    private

    def ensure_shared_type! measurement
      if !has_shared_types?(measurement.unit_name)
        incompatible_types
      end
    end

    def convert_to_base conversion_base
      if conversion_base.is_a?(Array)
        exponent * conversion_base.first.call(value)
      else
        exponent * value * conversion_base
      end
    end

    def conversion_base_for unit_type
      Alchemist.conversion_table[unit_type][unit_name]
    end

    def types
      Alchemist.measurement_for(unit_name)
    end

    def has_shared_types? other_unit_name
      shared_types(other_unit_name).length > 0
    end

    class ConversionWrap < Struct.new(:value)
    end

    def check_for_conversion_wrap(unit_name, arg)
      if can_perform_conversion?(unit_name, arg)
        wrap = check_operator_conversion(unit_name, arg)
        if wrap.is_a?(ConversionWrap)
          return wrap
        end
      end
    end

    def can_perform_conversion? unit_name, arg
      arg.is_a?(Measurement) && Alchemist.operator_actions[unit_name]
    end

    def check_operator_conversion unit_name, arg
      t1 = Alchemist.measurement_for(self.unit_name)[0]
      t2 = Alchemist.measurement_for(arg.unit_name)[0]
      Alchemist.operator_actions[unit_name].each do |s1, s2, new_type|
        if t1 == s1 && t2 == s2
          return ConversionWrap.new((value * arg.to_f).send(new_type))
        end
      end
    end

    def incompatible_types
      raise Exception, "Incompatible Types"
    end

    def convertor
      MeasurementConvertor.new(self)
    end
  end
end
