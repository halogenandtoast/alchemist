module Alchemist
  class CompoundMeasurement
    attr_accessor :numerators, :denominators

    def initialize(numerator)
      @coefficient = 1
      @numerators = [numerator]
      @denominators = []
    end

    def *(value)
      case value
      when Numeric
         @coefficient *= value
         self
      when Alchemist::Measurement
        @numerators << value
        return consolidate
      end
    end

    def consolidate
      compress_units
      set_coefficients
    end

    def compress_units
      @numerators.each_with_index do |numerator, n|
        @denominators.each_with_index do |denominator, d|
          remove_excess_units(numerator, n, denominator, d)
        end
      end
    end

    def remove_excess_units numerator, n, denominator, d
      if should_remove_units? numerator, denominator
        @numerators.delete_at(n)
        @denominators.delete_at(d)
        @coefficient *= (numerator / denominator)
      end
    end

    def should_remove_units? numerator, denominator
      return false if numerator.is_a?(Numeric) || denominator.is_a?(Numeric)
      (Alchemist.measurement_for(numerator.unit_name) & Alchemist.measurement_for(denominator.unit_name)).length > 0
    end

    def set_coefficients
      if @denominators.length == 0 && @numerators.length == 1
        @numerators[0] * @coefficient
      elsif @denominators.length == 0 && @numerators.length == 0
        @coefficient
      else
        self
      end
    end

    def method_missing(method, *attrs, &block)
      if Alchemist.measurement_for(method)
        @denominators << Alchemist.measurement(1, method)
        consolidate
      end
    end
  end
end
