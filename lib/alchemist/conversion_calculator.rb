module Alchemist
  class ConversionCalculator
    def initialize(from, parsed_unit)
      @from = from
      @parsed_unit = parsed_unit
    end

    def calculate
      Measurement.new(value / exponent, unit_name, exponent)
    end

    private
    attr_reader :from, :parsed_unit

    def exponent
      parsed_unit.exponent
    end

    def unit_name
      parsed_unit.unit_name
    end

    def value
      if proc_based?
        factor[1].call(base)
      else
        base / BigDecimal.new(factor.to_s)
      end
    end

    def proc_based?
      factor.is_a? Array
    end

    def base
      @base ||= BigDecimal.new(from.base(type).to_s)
    end

    def type
      @type ||= parsed_unit.guess_type(from)
    end

    def factor
      @factor = Alchemist.library.conversion_base_for(type, unit_name)
    end
  end
end
