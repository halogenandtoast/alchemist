class NumericConversion < Numeric
  @@british_standard_unit_prefixes = {
    :yotta => 10**24, :Y => 10**24,
    :zetta => 10**21, :Z => 10**21,
    :exa => 10**18, :E => 10**18,
    :peta => 10**15, :P => 10**15,
    :tera => 10**12, :T => 10**12,
    :giga => 10**9, :G => 10**9,
    :mega => 10**6, :M => 10**6,
    :kilo => 10**3, :k => 10**3,
    :hecto => 10**2, :h => 10**2,
    :deca => 10, :da => 10,
    :deci => 10**-1, :d => 10**-1,
    :centi => 10**-2, :c => 10**-2,
    :milli => 10**-3, :m => 10**-3,
    :micro => 10**-6, :u => 10**-6,
    :nano => 10**-9, :n => 10**-9,
    :pico => 10**-12, :p => 10**-12,
    :femto => 10**-15, :f => 10**-15,
    :atto => 10**-18, :a => 10**-18,
    :zepto => 10**-21, :z => 10**-21,
    :yocto => 10**-24, :y => 10**-24
  }
  
  @@british_standard_units = %w[ bits b lumens lm candelas cd newtons N metres meters m seconds s grams grammes g radians farads F henrys H joules J kelvin K ohms watts W litres liters l L coulombs C lux lx siemens S pascals Pa grays Gy webers Wb sieverts Si becquerels Bq]
  
  @@conversion_table = {
    :absorbed_radiation_dose => {
      :grays => 1.0, :Gy => 1.0,
      :rads => 1.0*10**-2
    },
    :angles => {
      :radians => 1.0,
      :degrees => 0.0174532925,
      :arcminutes => 2.90888208333*10**-4,
      :arcseconds => 4.848136806*10**-6,
      :mils => 9.817477*10**-4,
      :revolutions => 6.283185,
      :circles => 6.28318531,
      :right_angles => 1.57079633,
      :grads => 0.0157079633, :grades => 0.0157079633, :gradians => 0.0157079633, :gons => 0.0157079633
    },
    :capacitance => {
      :farads => 1.0, :F => 1.0,
      :abfarads => 1.0*10**9, :emus_of_capacitance => 1.0*10**9,
      :statfarads => 1.112650*10**-12, :esus_of_capacitance => 1.112650*10**-12
    },
    :distance => {
      :metres => 1.0, :meters => 1.0, :m => 1.0,
      :fermis => 1.0*10**-15,
      :microns => 1.0*10**-6,
      :chains => 20.1168,
      :inches => 25.4*10**-3, :in => 25.4*10**-3,
      :microinches => 2.54*10**-8,
      :mils => 2.54*10**-05,
      :rods => 5.029210,
      :leagues => 5556,
      :feet => 0.3048, :ft => 0.3048,
      :yards => 0.9144, :yd => 0.9144,
      :miles =>1609.344, :mi => 1609.344,
      :astronomical_units => 149.60*10**9, :au => 149.60*10**9, :ua => 149.60*10**9,
      :light_years => 9.461*10**15, :ly => 9.461*10**15,
      :parsecs => 30.857*10**15,
      :nautical_miles => 	1852.0,
      :admirality_miles => 185.3184,
      :fathoms => 1.8288,
      :cable_lengths => 185.2,
      :angstroms => 100.0*10**-12,
      :picas => 4.233333*10**-3,
      :printer_picas => 4.217518*10**-3,
      :points => 3.527778*10**-4,
      :printer_points => 3.514598*10**-4
    },
    :dose_equivalent => {
      :sieverts => 1.0, :Si => 1.0,
      :rems => 1.0*10**-2
    },
    :electric_charge => {
      :coulombs => 1.0, :C => 1.0,
      :abcoulombs => 10.0,
      :ampere_hours => 3.6*10**3,
      :faradays => 9.648534*10**4,
      :franklins => 3.335641*10**-10, :Fr => 3.335641*10**-10,
      :statcoulombs => 3.335641*10**-10
    },
    :electric_conductance => {
      :siemens => 1.0, :S => 1.0, :mho => 1.0,
      :abmho => 1.0*10**9, :absiemens => 1.0*10**9,
      :statmho => 1.112650*10**-12, :statsiemens => 1.112650*10**-12
    },
    :electrical_impedance => {
      :ohms => 1.0,
      :abohms => 1.0*10**-9, :emus_of_resistance => 1.0*10**-9,
      :statohms => 8.987552*10**11, :esus_of_resistance => 8.987552*10**11
    },
    :electromotive_force => {
      :volts => 1.0, :V => 1.0,
      :abvolts => 1.0*10**-8, :emus_of_electric_potential => 1.0*10**-8,
      :statvolts => 2.997925*10**2, :esus_of_electric_potential => 2.997925*10**2
    },
    :energy => {
      :joules => 1.0, :J => 1.0, :watt_seconds => 1.0,
      :watt_hours => 3.6*10**3,
      :tons_of_tnt => 4.184*10**9,
      :therms => 1.05506*10**8,
      :us_therms => 1.054804*10**8,
      :kilowatt_hours => 3.6*10**6,
      :kilocalories => 4184.0,
      :calories => 4.184,
      :mean_kilocalories => 4190,
      :mean_calories => 4.190,
      :it_kilocalories => 4186.8,
      :it_calories => 4.1868,
      :foot_poundals => 4.214011*10**-2,
      :foot_pound_force => 1.355818,
      :ergs =>  1.0*10**-7,
      :electronvolts => 1.602176*10**-19, :eV => 1.602176*10**-19,
      :british_thermal_units => 1.054350*10**3,
      :mean_british_thermal_units => 1.05587*10**3,
      :it_british_thermal_units => 1.055056*10**3
    },
    :force => {
      :newtons => 1.0, :N => 1.0,
      :dynes => 1.0*10**-5, :dyn => 1.0*10**-5,
      :kilogram_force => 9.80665, :kgf => 9.80665, :kiloponds => 9.80665, :kp => 9.80665,
      :kips => 4.448222*10**3,
      :ounce_force => 2.780139*10**-1, :ozf => 2.780139*10**-1,
      :poundals => 1.382550*10**-1,
      :pound_force => 4.448222, :lbf => 4.448222,
      :ton_force => 8.896443*10**3
    },
    :illuminance => {
      :lux => 1.0, :lx => 1.0, :lumens_per_square_metre => 1.0, :lumens_per_square_meter => 1.0,
      :phots => 1.0*10**4, :ph => 1.0*10**4,
      :lumens_per_square_foot => 10.76391, :footcandle => 10.76391
    },
   :inductance => {
      :henrys => 1.0, :H => 1.0,
      :abhenrys => 1.0*10**-9, :emus_of_inductance => 1.0*10**-9,
      :stathenrys => 8.987552*10**11, :esus_of_inductance => 8.987552*10**11
    },
    :information_storage => {
      :bits => 1.0, :b => 1.0,
      :bytes => 8.0, 
      :nibbles => 4.0, :nybbles => 4.0
    },
    :luminous_flux => {
      :lumens => 1.0, :lm => 1.0
    },
    :luminous_intensity => {
      :candelas => 1.0, :cd => 1.0
    },
    :magnetic_flux => {
      :webers => 1.0, :Wb => 1.0,
      :maxwells => 1.0*10**-8, :Mx => 1.0*10**-8,
      :unit_poles => 1.256637*10**-7
    },
    :magnetic_inductance => {
      :teslas => 1.0, :T => 1.0,
      :gammas => 1.0*10**-9,
      :gauss => 1.0*10**-4, :Gs => 1.0*10**-4, :G => 1.0*10**-4
    },
    :mass => {
      :grams => 1.0, :grammes => 1.0, :g => 1.0,
      :carats => 2.0*10**-1,
      :ounces => 2.834952*10**1, :oz => 2.834952*10**1,
      :pennyweights => 1.555174, :dwt => 1.555174,
      :pounds => 453.59237, :lb => 453.59237, :lbs => 453.59237,
      :troy_pounds => 373.2417, :apothecary_pounds => 373.2417,
      :slugs => 14593.9029,
      :assay_tons => 29.1667, :AT => 29.1667,
      :metric_tons => 1000000,
      :tons => 907184.74, :short_tons => 907184.74 
    },
    :power => {
      :watts => 1.0, :W => 1.0,
      :british_thermal_units_per_hour => 2.928751*10**-1,
      :it_british_thermal_units_per_hour => 2.930711*10**-1,
      :british_thermal_units_per_second => 1.054350*10**3,
      :it_british_thermal_units_per_second => 1.055056*10**3,
      :calories_per_minute => 6.973333*10**-2,
      :calories_per_second => 4.184,
      :ergs_per_second => 1.0*10**-7,
      :foot_pound_force_per_hour => 3.766161*10**-4,
      :foot_pound_force_per_minute => 2.259697*10**-2,
      :foot_pound_force_per_second => 1.355818,
      :horsepower => 7.456999*10**2,
      :boiler_horsepower => 9.80950*10**3,
      :electric_horsepower => 7.46*10**2,
      :metric_horsepower => 7.354988*10**2,
      :uk_horsepower => 7.4570*10**2,
      :water_horsepower => 7.46043*10**2,
      :kilocalorie_per_minute => 6.973333*10,
      :kilocalorie_per_second => 4.184*10**3,
      :tons_of_refrigeration => 3.516853*10**3
    },
    :pressure => {
      :pascals => 1.0, :Pa => 1.0,
      :atmospheres => 1.01325*10**5,
      :technical_atmospheres => 9.80665*10**4,
      :bars => 1.0*10**5,
      :centimeters_of_mercury => 1.333224*10**3,
      :centimeters_of_water => 98.0665, :gram_force_per_square_centimeter => 98.0665,
      :dynes_per_square_centimeter => 1.0*10**-1,
      :feet_of_mercury => 4.063666*10**4,
      :feet_of_water => 2.989067*10**3,
      :inches_of_mercury => 3.386389*10**3,
      :inches_of_water =>  2.490889*10**2,
      :kilogram_force_per_square_centimeter => 9.80665*10**4,
      :kilogram_force_per_square_meter => 9.80665,
      :kilogram_force_per_square_millimeter =>  9.80665*10**6,
      :kips_per_square_inch => 6.894757*10**6, :ksi => 6.894757*10**6,
      :millibars => 1.0*10**2, :mbars => 1.0*10**2,
      :millimeters_of_mercury => 1.333224*10**2,
      :millimeters_of_water => 9.80665,
      :poundals_per_square_foot => 1.488164,
      :pound_force_per_square_foot => 47.88026,
      :pound_force_per_square_inch => 6.894757*10**3, :psi => 6.894757*10**3,
      :torrs => 1.333224*10**2
    },
    :radioactivity => {
      :becquerels => 1.0, :Bq => 1.0,
      :curies => 3.7*10**10, :Ci => 3.7*10**10
    },
    :temperature => {
      :kelvin => 1.0, :K => 1.0,
      :degrees_celsius => [Proc.new{ |t| t + 273.15 }, Proc.new{ |t| t - 273.15 }], :degrees_centrigrade => [Proc.new{ |t| t + 273.15 }, Proc.new{ |t| t - 273.15 }],
      :degrees_fahrenheit => [Proc.new{ |t| t * (5.0/9.0) + 459.67 }, Proc.new{ |t| t * (9.0/5.0) - 459.67 }],
      :rankines => 1.8
    }, 
    :time => {
      :seconds => 1.0, :s => 1.0,
      :minutes => 60.0, :min => 60.0,
      :sidereal_minutes => 5.983617,
      :hours => 3600.0, :hr => 3600.0,
      :sidereal_hours => 3.590170*10**3,
      :days => 86400.0,
      :sidereal_days => 8.616409*10**4,
      :shakes => 1.0*10**-8,
      :years => 3.1536*10**7,
      :sidereal_years => 3.155815*10**7,
      :tropical_years => 3.155693*10**7
    },
    :volume => {
      :litres => 1.0, :liters => 1.0, :l => 1.0, :L => 1.0,
      :barrels => 1.589873*10**2,
      :bushels => 3.523907*10**1,
      :cubic_meters => 1000.0,
      :cups => 2.365882*10**-1,
      :imperial_fluid_ounces => 0.0284130742,
      :fluid_ounces => 0.0295735296,
      :imperial_gallons => 4.54609,
      :gallons => 3.785412,
      :imperial_gills => 1.420653*10**-1,
      :gills => 1.182941*10**-1, :gi => 1.182941*10**-1,
      :pints => 5.506105*10**-1,
      :liquid_pints => 4.731765*10**-1,
      :quarts => 1.101221,
      :liquid_quarts => 9.463529*10**-1,
      :tablespoons => 0.0147867648,
      :teaspoons => 0.00492892159
    }
  }
  
  
  def initialize(value, from)
    @from = from.to_sym
    @value = value
  end
  
  def self.conversion_table
    @@conversion_table
  end
  
  def per(type)
    # todo
  end
  
  def to(to)
    to = to.to_sym
    f_mult, f_type = self.class.parse_prefix(@from)
    t_mult, t_type = self.class.parse_prefix(to)
    @@conversion_table.each do |type, conversions|
      if conversions.keys.include?(f_type) && conversions.keys.include?(t_type)
        if conversions[f_type].is_a?(Array) && conversions[t_type].is_a?(Array)
          return t_mult * conversions[t_type][1].call(f_mult * conversions[f_type][0].call(@value))
        elsif conversions[f_type].is_a?(Array)
          return (f_mult * conversions[f_type][0].call(@value)) /  (t_mult * conversions[t_type])
        elsif conversions[t_type].is_a?(Array)
          return t_mult * conversions[t_type][1].call(f_mult * conversions[f_type] * @value)
        else
          return @value * (f_mult * conversions[f_type]) / (t_mult * conversions[t_type])
        end
      end
    end
    raise Exception, "could not convert types"
  end
  
  def from(to)
    temp = @from
    @from = to
    to(temp)
  end
  
  def self.parse_prefix(unit)
    @@british_standard_unit_prefixes.each do |prefix, value|
      if unit.to_s =~ /^#{prefix}.+/ && @@british_standard_units.include?(unit.to_s.gsub(/^#{prefix}/,''))
        return [value, unit.to_s.gsub(/^#{prefix}/,'').to_sym]
      end
    end
    [1.0, unit]
  end
end