module Alchemist
  class Configuration

    DATA_DIR = File.join(File.dirname(__FILE__), "data")
    DEFAULT_UNITS_FILE = File.join(DATA_DIR, "units.yml")
    DEFAULT_SI_UNITS_FILE = File.join(DATA_DIR, "si_units.yml")
    DEFAULT_BINARY_PREFIXES_FILE = File.join(DATA_DIR, "binary_prefixes.yml")
    DEFAULT_UNIT_PREFIXES_FILE = File.join(DATA_DIR, "unit_prefixes.yml")

    attr_accessor :use_si

    def initialize
      @use_si = false
    end

    def use_si?
      @use_si
    end
  end
end
