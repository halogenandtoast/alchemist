require 'alchemist'

module Alchemist
  class Measurement
    def geospatial
      Alchemist::Earth.new(self).geospatial
    end
  end
end
