module Alchemist
  class CompoundNumericConversion
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
      when Alchemist::NumericConversion
        @numerators << value
        return consolidate
      end
    end

    # TODO: minify this
    def consolidate
      @numerators.each_with_index do |numerator, n|
        @denominators.each_with_index do |denominator, d|
          next if numerator.is_a?(Numeric)
          next if denominator.is_a?(Numeric)
          if (Alchemist.measurement_for(numerator.unit_name) & Alchemist.measurement_for(denominator.unit_name)).length > 0
            value = numerator / denominator
            @numerators.delete_at(n)
            @denominators.delete_at(d)
            @coefficient *= value
          end
        end
      end
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
