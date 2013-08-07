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
      if multiplicand.is_a?(Numeric)
        Measurement.new(value * multiplicand, unit_name, exponent)
      else
        try_raising_dimension(multiplicand)
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

    def types
      Alchemist.measurement_for(unit_name)
    end

    def shared_types other_unit_name
      types & Alchemist.measurement_for(other_unit_name)
    end

    def geospatial
      if types.include?(:angles)
        geospatial_angle_to_arc
      elsif types.include?(:distance)
        geospatial_arc_to_angle
      else
        raise Exception, "geospatial must either be angles or distance"
      end
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

    def has_shared_types? other_unit_name
      shared_types(other_unit_name).length > 0
    end

    def try_raising_dimension(measurement)
      valid_types = shared_types(measurement.unit_name)
      Alchemist.operator_actions[:*].each do |s1, s2, new_type|
        if (valid_types & [s1, s2]).any?
          return Alchemist.measure(value * measurement.to_f, new_type)
        end
      end
      incompatible_types
    end

    def incompatible_types
      raise Exception, "Incompatible Types"
    end

    def convertor
      MeasurementConvertor.new(self)
    end

    def geospatial_angle_to_arc
      to.radians.to_f.radians_latitude.to.earth_arc_meters.to_f.meters
    end

    def geospatial_arc_to_angle
      to.meters.to_f.earth_arc_meters.to.radians_latitude.to_f.radians
    end
  end
end
