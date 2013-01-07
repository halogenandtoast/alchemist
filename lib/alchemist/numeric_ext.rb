module Alchemist
  module Conversion
    def method_missing unit_name, *args, &block
      exponent, unit_name = Alchemist.parse_prefix(unit_name)
      Conversions[ unit_name ] || super( unit_name, *args, &block )
      NumericConversion.new self, unit_name, exponent
    end
  end
end

class Numeric
  include Alchemist::Conversion
end
