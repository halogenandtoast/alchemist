require 'bigdecimal'
require 'alchemist/prefix_parser'

module Alchemist
  class MeasurementConvertor
    def initialize from
      @from = from
    end

    def method_missing method, *args, &block
      exponent, unit_name = PrefixParser.new.parse(method)
      convert(from.shared_types(unit_name), unit_name, args.first || exponent)
    end

    private
    attr_reader :from

    def library
      Library.instance
    end

    def convert types, unit_name, exponent
      if type = types[0]
        convert_from_type(type, unit_name, exponent)
      else
        raise Exception, "Incompatible Types"
      end
    end

    def convert_from_type(type, unit_name, exponent)
      conversion_base = BigDecimal.new(from.base(type).to_s)
      conversion_factor = library.conversion_base_for(type, unit_name)

      value = value_from(conversion_base, conversion_factor)
      Measurement.new(value / exponent, unit_name, exponent)
    end

    def value_from(base, factor)
      if proc_based?(factor)
        factor[1].call(base)
      else
        base / BigDecimal.new(factor.to_s)
      end

    end

    def proc_based? conversion_factor
      conversion_factor.is_a? Array
    end
  end
end
