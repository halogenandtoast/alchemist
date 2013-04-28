require 'yaml'
require 'alchemist/si_units'
require 'alchemist/unit_prefixes'
require 'alchemist/binary_prefixes'
require 'alchemist/exceptions'

module Alchemist
  class ConversionTable

    def load_all( yaml_file )
      @conversions = load_yaml(yaml_file).merge(proc_based)
    end

    private

    def load_yaml(yaml_file)
      begin
        YAML.load_file(yaml_file)
      rescue SyntaxError
        raise YamlSyntaxError
      end
    end


    def proc_based
      {
        :density => {
          :specific_gravity => 1, :sg => 1,
          :brix     => [lambda{ |d| -261.3 / (d - 261.3) }, lambda{ |d| 261.3 - (261.3 / d) }],
          :plato    => [lambda{ |d| -260.0 / (d - 260.0) }, lambda{ |d| 260.0 - (260.0 / d) }],
          :baume    => [lambda{ |d| -145.0 / (d - 145.0) }, lambda{ |d| 145.0 - (145.0 / d) }]
        },
        :temperature => temperature
      }
    end

    def temperature
      {
          :kelvin => 1.0, :K => 1.0,

          :celsius => celsius_conversion,
          :centrigrade => celsius_conversion,
          :degree_celsius => celsius_conversion,
          :degree_centrigrade => celsius_conversion,
          :degrees_celsius => celsius_conversion,
          :degrees_centrigrade => celsius_conversion,
          :fahrenheit => fahrenheit_conversion,
          :degree_fahrenheit => fahrenheit_conversion,
          :degrees_fahrenheit => fahrenheit_conversion,
          :rankine => 1.8, :rankines => 1.8
        }
    end

    def to_celsius
      lambda{ |t| t + 273.15 }
    end

    def from_celsius
      lambda{ |t| t - 273.15 }
    end

    def celsius_conversion
      [to_celsius, from_celsius]
    end

    def to_fahrenheit
      lambda{ |t| (t + 459.67) * (5.0/9.0) }
    end

    def from_fahrenheit
      lambda{ |t| t * (9.0/5.0) - 459.67 }
    end

    def fahrenheit_conversion
      [to_fahrenheit, from_fahrenheit]
    end
  end
end
