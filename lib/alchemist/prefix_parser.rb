module Alchemist
  class PrefixParser
    attr_reader :unit_name, :exponent

    def initialize(unit)
      @unit = unit
      matches = unit.to_s.match(prefix_matcher)
      prefix, parsed_unit = matches.captures

      if prefix && library.si_units.include?(parsed_unit)
        @exponent = library.exponent_for(parsed_unit, prefix.to_sym)
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
      library.measurement_for(from.unprefixed_unit_name) & library.measurement_for(unit_name)
    end


    def library
      Alchemist.library
    end

    def generate_prefix_matcher
      prefix_keys = library.unit_prefixes.keys.map(&:to_s).sort{ |a,b| b.length <=> a.length }
      %r{^(#{prefix_keys.join('|')})?(.+)}
    end
  end
end
