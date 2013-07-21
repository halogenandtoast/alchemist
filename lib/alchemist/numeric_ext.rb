module Alchemist
  module Conversion
    def method_missing unit_name, *args, &block
      exponent, unit_name = Alchemist.parse_prefix(unit_name)
      if Alchemist.has_measurement?(unit_name)
        Alchemist.measurement self, unit_name, exponent
      else
        super
      end
    end
  end
end
