module Alchemist
  class Earth
    RADIUS = Alchemist.measure(6378100, :meters)

    def initialize measurement
      @measurement = measurement
    end

    def geospatial
      if types.include?(:angles)
        geospatial_angle_to_arc
      elsif types.include?(:distance)
        geospatial_arc_to_angle
      else
        raise GeospatialArgumentError, "geospatial must either be angles or distance"
      end
    end

    private
    attr_reader :measurement, :base

    def types
      measurement.types
    end

    def geospatial_angle_to_arc
      measurement.to(:radians).to_f * RADIUS
    end

    def geospatial_arc_to_angle
      Alchemist.measure(measurement.to(:meters) / RADIUS, :radians)
    end
  end
end
