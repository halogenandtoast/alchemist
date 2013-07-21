require 'bigdecimal'

module Alchemist
  class MeasurementConvertor
    def initialize from
      @from = from
    end

    def method_missing method, *args, &block
      exponent, unit_name = Alchemist.parse_prefix(method)
      convert(from.shared_types(unit_name), unit_name, exponent)
    end

    private
    attr_reader :from

    def convert types, unit_name, exponent
      if type = types[0]
        conversion_base = BigDecimal.new(from.base(type).to_s)
        conversion_factor = Alchemist.conversion_table[type][unit_name]
        if proc_based?(conversion_factor)
          Measurement.new(conversion_factor[1].call(conversion_base), unit_name, exponent)
        else
          Measurement.new(conversion_base / BigDecimal.new(conversion_factor.to_s), unit_name, exponent)
        end
      else
        raise Exception, "Incompatible Types"
      end
    end

    def proc_based? conversion_factor
      conversion_factor.is_a? Array
    end
  end
end
