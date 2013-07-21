module Alchemist
  class MeasurementConvertor
    def initialize from
      @from = from
    end

    def method_missing method, *args, &block
      exponent, unit_name = Alchemist.parse_prefix(method)
      arg = args.first

      if Alchemist.measurement_for(unit_name)
        convert shared_types(unit_name), unit_name, exponent
      else
        super
      end
    end

    private
    attr_reader :from

    def shared_types unit_name
      from.shared_types unit_name
    end

    def base type
      from.base type
    end

    def convert types, unit_name, exponent
      if type = types[0]
        convert_from_type type, unit_name, exponent
      else
        raise Exception, "Incompatible Types"
      end
    end

    def convert_from_type type, unit_name, exponent
      if(Alchemist.conversion_table[type][unit_name].is_a?(Array))
        Alchemist.conversion_table[type][unit_name][1].call(base(type))
      else
        Measurement.new(base(type) / (exponent * Alchemist.conversion_table[type][unit_name]), unit_name)
      end
    end

  end
end
