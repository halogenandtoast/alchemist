module Alchemist
  class PrefixParser
    attr_reader :unit_name, :exponent

    def initialize(unit)
      @unit = unit
      matches = unit.to_s.match(prefix_matcher)
      prefix, parsed_unit = matches.captures

      if prefix && library.si_units.include?(parsed_unit)
        value = prefixed_value_for(prefix.to_sym, parsed_unit)
        @exponent = value
        @unit_name = parsed_unit.to_sym
      else
        @exponent = 1
        @unit_name = unit
      end
    end

    def prefix_matcher
      @prefix_matcher ||= generate_prefix_matcher
    end

    def shares_type?(from)
      guess_type(from)
    end

    def guess_type(from)
      shared_types(from).first
    end

    private

    def shared_types from
      library.measurement_for(from.unit_name) & library.measurement_for(unit_name)
    end


    def library
      Alchemist.library
    end

    def generate_prefix_matcher
      prefix_keys = library.unit_prefixes.keys.map(&:to_s).sort{ |a,b| b.length <=> a.length }
      %r{^(#{prefix_keys.join('|')})?(.+)}
    end

    def prefixed_value_for prefix, unit
      if use_binary_prefix? unit
        library.binary_prefixes[prefix]
      else
        library.unit_prefixes[prefix]
      end
    end

    def use_binary_prefix? unit
      !Alchemist.config.use_si? && library.measurement_for(unit).include?(:information_storage)
    end
  end
end
