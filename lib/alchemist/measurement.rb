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
      CompoundNumericConversion.new self
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

    def to type = nil
      unless type
        self
      else
        send type
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

    def convert_from_type type, unit_name, exponent
      if(Alchemist.conversion_table[type][unit_name].is_a?(Array))
        Alchemist.conversion_table[type][unit_name][1].call(base(type))
      else
        Measurement.new(base(type) / (exponent * Alchemist.conversion_table[type][unit_name]), unit_name)
      end
    end

    def convert types, unit_name, exponent
      if type = types[0]
        convert_from_type type, unit_name, exponent
      else
        raise Exception, "Incompatible Types"
      end
    end

    def multiply multiplicand
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

    def can_perform_conversion? unit_name, arg
      arg.is_a?(Measurement) && Alchemist.operator_actions[unit_name]
    end

    def types
      Alchemist.measurement_for(unit_name)
    end

    def shared_types other_unit_name
      types & Alchemist.measurement_for(other_unit_name)
    end

    def has_shared_types? other_unit_name
      shared_types(other_unit_name).length > 0
    end

    class ConversionWrap < Struct.new(:value)
    end

    def method_missing unit_name, *args, &block
      exponent, unit_name = Alchemist.parse_prefix(unit_name)
      arg = args.first

      if Alchemist.measurement_for(unit_name)
        convert shared_types(unit_name), unit_name, exponent
      else
        super
      end
    end

    def check_for_conversion_wrap(unit_name, arg)
      if can_perform_conversion?(unit_name, arg)
        wrap = check_operator_conversion(unit_name, arg)
        if wrap.is_a?(ConversionWrap)
          return wrap
        end
      end
    end

    def incompatible_types
      raise Exception, "Incompatible Types"
    end
  end
end
