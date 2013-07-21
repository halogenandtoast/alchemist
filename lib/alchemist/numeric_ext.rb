module Alchemist
  module Conversion
    NON_ALCHEMIST_METHODS = [:to_s, :to_str, :to_a, :to_ary]

    def method_missing unit_name, *args, &block
      return super if NON_ALCHEMIST_METHODS.include?(unit_name)

      exponent, unit_name = Alchemist.parse_prefix(unit_name)
      if Alchemist.has_measurement?(unit_name)
        Alchemist.measurement self, unit_name, exponent
      else
        super
      end
    end
  end
end
