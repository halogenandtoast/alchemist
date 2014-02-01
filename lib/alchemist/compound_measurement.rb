module Alchemist
  class CompoundMeasurement
    include Comparable
    attr_accessor :numerators, :denominators

    def initialize(numerator)
      @coefficient = numerator.value
      @numerators = [numerator / @coefficient]
      @denominators = []
    end

    def <=> other
      if @coefficient == other.coefficient
        [@numerators, @denominators] <=> [other.numerators, other.denominators]
      else
        @coefficient <=> other.coefficient
      end
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

    private

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
      (Alchemist.library.measurement_for(numerator.unit_name) & Alchemist.library.measurement_for(denominator.unit_name)).length > 0
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
      if Alchemist.library.measurement_for(method)
        @denominators << Alchemist.measure(1, method)
        consolidate
      end
    end

    protected

    attr_reader :coefficient
  end
end
