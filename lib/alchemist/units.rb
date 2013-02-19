require 'yaml'
require 'alchemist/si_units'
require 'alchemist/unit_prefixes'
require 'alchemist/binary_prefixes'

module Alchemist
  class ConversionTable

    def load_all
      @conversions ||= load_yaml.merge(proc_based)
    end

    private

    def load_yaml
      YAML.load_file(yaml_file)
    end

    def yaml_file
      File.join(File.dirname(__FILE__), "units.yml")
    end

    def proc_based
      {
        :density => {
          :specific_gravity => 1, :sg => 1,
          :brix     => [Proc.new{ |d| -261.3 / (d - 261.3) }, Proc.new{ |d| 261.3 - (261.3 / d) }],
          :plato    => [Proc.new{ |d| -260.0 / (d - 260.0) }, Proc.new{ |d| 260.0 - (260.0 / d) }],
          :baume    => [Proc.new{ |d| -145.0 / (d - 145.0) }, Proc.new{ |d| 145.0 - (145.0 / d) }]
        },
        :temperature => {
          :kelvin => 1.0, :K => 1.0,

          :celsius => [Proc.new{ |t| t + 273.15 }, Proc.new{ |t| t - 273.15 }], :centrigrade => [Proc.new{ |t| t + 273.15 }, Proc.new{ |t| t - 273.15 }],
          :degree_celsius => [Proc.new{ |t| t + 273.15 }, Proc.new{ |t| t - 273.15 }], :degree_centrigrade => [Proc.new{ |t| t + 273.15 }, Proc.new{ |t| t - 273.15 }],
          :degrees_celsius => [Proc.new{ |t| t + 273.15 }, Proc.new{ |t| t - 273.15 }], :degrees_centrigrade => [Proc.new{ |t| t + 273.15 }, Proc.new{ |t| t - 273.15 }],
          :fahrenheit => [Proc.new{ |t| (t + 459.67) * (5.0/9.0) }, Proc.new{ |t| t * (9.0/5.0) - 459.67 }],
          :degree_fahrenheit => [Proc.new{ |t| (t + 459.67) * (5.0/9.0) }, Proc.new{ |t| t * (9.0/5.0) - 459.67 }],
          :degrees_fahrenheit => [Proc.new{ |t| (t + 459.67) * (5.0/9.0) }, Proc.new{ |t| t * (9.0/5.0) - 459.67 }],
          :rankine => 1.8, :rankines => 1.8
        }
      }
    end
  end
end
