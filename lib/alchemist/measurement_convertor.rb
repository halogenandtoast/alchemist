require 'bigdecimal'
require 'alchemist/prefix_parser'

module Alchemist
  class MeasurementConvertor
    def initialize from
      @from = from
    end

    def method_missing method, *args, &block
      parsed_unit = parse_prefix(method)
      convert(parsed_unit)
    end

    private
    attr_reader :from

    def parse_prefix(name)
      PrefixParser.new(name)
    end


    def convert parsed_unit
      if parsed_unit.shares_type?(from)
        ConversionCalculator.new(from, parsed_unit).calculate
      else
        raise IncompatibleTypeError, "Incompatible Types"
      end
    end
  end
end
