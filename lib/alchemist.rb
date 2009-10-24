module Alchemist
  @@si_units = %w[m meter metre meters metres liter litre litres liters l L farad farads F coulombs C gray grays Gy siemen siemens S mhos mho ohm ohms volt volts V ]
  @@si_units + %w[joule joules J newton newtons N lux lx henry henrys H b B bits bytes bit byte lumen lumens lm candela candelas cd]
  @@si_units + %w[tesla teslas T gauss Gs G gram gramme grams grammes g watt watts W pascal pascals Pa]
  @@si_units + %w[becquerel becquerels Bq curie curies Ci]
  @@conversion_table = {
    :absorbed_radiation_dose => {
      :gray => 1.0, :grays => 1.0, :Gy => 1.0,
      :rad => 1.0*10**-2, :rads => 1.0*10**-2
    },
    :angles => {
      :radian => 1.0, :radians => 1.0,
      :degree => 0.0174532925, :degrees => 0.0174532925,
      :arcminute => 2.90888208333*10**-4, :arcminutes => 2.90888208333*10**-4,
      :arcsecond => 4.848136806*10**-6, :arcseconds => 4.848136806*10**-6,
      :mil => 9.817477*10**-4, :mils => 9.817477*10**-4,
      :revolution => 6.283185, :revolutions => 6.283185,
      :circle => 6.28318531, :circles => 6.28318531,
      :right_angle => 1.57079633, :right_angles => 1.57079633,
      :grad => 0.0157079633, :grade => 0.0157079633, :gradian => 0.0157079633, :gon => 0.0157079633, :grads => 0.0157079633, :grades => 0.0157079633, :gradians => 0.0157079633, :gons => 0.0157079633
    },
    :area => {
      :square_meter => 1.0, :square_meters => 1.0, :square_metre => 1.0, :square_metres => 1.0,
      :acre => 4.046873*10**3, :acres => 4.046873*10**3, 
      :are => 1.0*10**2, :ares => 1.0*10**2, :a => 1.0*10**2,
      :barn => 1.0*10**-28, :barns => 1.0*10**-28, :b => 1.0*10**-28,
      :circular_mil => 5.067075*10**-10, :circular_mils => 5.067075*10**-10,
      :hectare => 1.0*10**4, :hectares => 1.0*10**4, :ha => 1.0*10**4,
      :square_foot => 9.290304*10**-2, :square_feet => 9.290304*10**-2,
      :square_inch => 6.4516*10**-4, :square_inches => 6.4516*10**-4,
      :square_mile => 2.589988*10**6, :square_miles => 2.589988*10**6,
      :square_yard => 8.361274*10**-1, :square_yards => 8.361274*10**-1
    },
    :capacitance => {
      :farad => 1.0, :farads => 1.0, :F => 1.0,
      :abfarad => 1.0*10**9, :emu_of_capacitance => 1.0*10**9, :abfarads => 1.0*10**9, :emus_of_capacitance => 1.0*10**9,
      :statfarad => 1.112650*10**-12, :esu_of_capacitance => 1.112650*10**-12, :statfarads => 1.112650*10**-12, :esus_of_capacitance => 1.112650*10**-12
    },
    :distance => {
      :meter => 1.0, :metres => 1.0, :meters => 1.0, :m => 1.0,
      :fermi => 1.0*10**-15, :fermis => 1.0*10**-15,
      :micron => 1.0*10**-6, :microns => 1.0*10**-6,
      :chain => 20.1168, :chains => 20.1168,
      :inch => 25.4*10**-3, :inches => 25.4*10**-3, :in => 25.4*10**-3,
      :microinch => 2.54*10**-8, :microinches => 2.54*10**-8,
      :mil => 2.54*10**-05, :mils => 2.54*10**-05,
      :rod => 5.029210, :rods => 5.029210,
      :league => 5556, :leagues => 5556,
      :foot => 0.3048, :feet => 0.3048, :ft => 0.3048,
      :yard => 0.9144, :yards => 0.9144, :yd => 0.9144,
      :mile =>1609.344, :miles =>1609.344, :mi => 1609.344,
      :astronomical_unit => 149.60*10**9, :astronomical_units => 149.60*10**9, :au => 149.60*10**9, :ua => 149.60*10**9,
      :light_year => 9.461*10**15, :light_years => 9.461*10**15, :ly => 9.461*10**15,
      :parsec => 30.857*10**15, :parsecs => 30.857*10**15,
      :nautical_mile => 1852.0, :nautical_miles => 1852.0,
      :admirality_mile => 185.3184, :admirality_miles => 185.3184,
      :fathom => 1.8288, :fathoms => 1.8288,
      :cable_length => 185.2, :cable_lengths => 185.2,
      :angstrom => 100.0*10**-12, :angstroms => 100.0*10**-12,
      :pica => 4.233333*10**-3, :picas => 4.233333*10**-3,
      :printer_pica => 4.217518*10**-3, :printer_picas => 4.217518*10**-3,
      :point => 3.527778*10**-4, :points => 3.527778*10**-4,
      :printer_point => 3.514598*10**-4, :printer_points => 3.514598*10**-4
    },
    :dose_equivalent => {
      :sievert => 1.0, :sieverts => 1.0, :Si => 1.0,
      :rem => 1.0*10**-2, :rems => 1.0*10**-2
    },
    :electric_charge => {
      :coulomb => 1.0, :coulombs => 1.0, :C => 1.0,
      :abcoulomb => 10.0, :abcoulombs => 10.0,
      :ampere_hour => 3.6*10**3, :ampere_hours => 3.6*10**3,
      :faraday => 9.648534*10**4, :faradays => 9.648534*10**4,
      :franklin => 3.335641*10**-10, :franklins => 3.335641*10**-10, :Fr => 3.335641*10**-10,
      :statcoulomb => 3.335641*10**-10, :statcoulombs => 3.335641*10**-10
    },
    :electric_conductance => {
      :siemen => 1.0, :siemens => 1.0, :S => 1.0, :mho => 1.0,
      :abmho => 1.0*10**9, :absiemen => 1.0*10**9, :absiemens => 1.0*10**9,
      :statmho => 1.112650*10**-12, :statsiemen => 1.112650*10**-12, :statsiemens => 1.112650*10**-12
    },
    :electrical_impedance => {
      :ohm => 1.0, :ohms => 1.0,
      :abohm => 1.0*10**-9, :emu_of_resistance => 1.0*10**-9, :abohms => 1.0*10**-9, :emus_of_resistance => 1.0*10**-9,
      :statohm => 8.987552*10**11, :esu_of_resistance => 8.987552*10**11, :statohms => 8.987552*10**11, :esus_of_resistance => 8.987552*10**11
    },
    :electromotive_force => {
      :volt => 1.0, :volts => 1.0, :V => 1.0,
      :abvolt => 1.0*10**-8, :emu_of_electric_potential => 1.0*10**-8, :abvolts => 1.0*10**-8, :emus_of_electric_potential => 1.0*10**-8,
      :statvolt => 2.997925*10**2, :esu_of_electric_potential => 2.997925*10**2, :statvolts => 2.997925*10**2, :esus_of_electric_potential => 2.997925*10**2
    },
    :energy => {
      :joule => 1.0, :joules => 1.0, :J => 1.0, :watt_second => 1.0, :watt_seconds => 1.0,
      :watt_hour => 3.6*10**3, :watt_hours => 3.6*10**3,
      :ton_of_tnt => 4.184*10**9, :tons_of_tnt => 4.184*10**9,
      :therm => 1.05506*10**8, :therms => 1.05506*10**8,
      :us_therm => 1.054804*10**8, :us_therms => 1.054804*10**8,
      :kilowatt_hour => 3.6*10**6, :kilowatt_hours => 3.6*10**6,
      :kilocalorie => 4184.0, :kilocalories => 4184.0,
      :calorie => 4.184, :calories => 4.184,
      :mean_kilocalorie => 4190, :mean_kilocalories => 4190,
      :mean_calorie => 4.190, :mean_calories => 4.190,
      :it_kilocalorie => 4186.8, :it_kilocalories => 4186.8,
      :it_calorie => 4.1868, :it_calories => 4.1868,
      :foot_poundal => 4.214011*10**-2, :foot_poundals => 4.214011*10**-2,
      :foot_pound_force => 1.355818,
      :erg =>  1.0*10**-7, :ergs =>  1.0*10**-7,
      :electronvolt => 1.602176*10**-19, :electronvolts => 1.602176*10**-19, :eV => 1.602176*10**-19,
      :british_thermal_unit => 1.054350*10**3, :british_thermal_units => 1.054350*10**3,
      :mean_british_thermal_unit => 1.05587*10**3, :mean_british_thermal_units => 1.05587*10**3,
      :it_british_thermal_unit => 1.055056*10**3, :it_british_thermal_units => 1.055056*10**3
    },
    :force => {
      :newton => 1.0, :newtons => 1.0, :N => 1.0,
      :dyne => 1.0*10**-5, :dynes => 1.0*10**-5, :dyn => 1.0*10**-5,
      :kilogram_force => 9.80665, :kgf => 9.80665, :kilopond => 9.80665, :kiloponds => 9.80665, :kp => 9.80665,
      :kip => 4.448222*10**3, :kips => 4.448222*10**3,
      :ounce_force => 2.780139*10**-1, :ozf => 2.780139*10**-1,
      :poundal => 1.382550*10**-1, :poundals => 1.382550*10**-1,
      :pound_force => 4.448222, :lbf => 4.448222,
      :ton_force => 8.896443*10**3
    },
    :illuminance => {
      :lux => 1.0, :lx => 1.0, :lumens_per_square_metre => 1.0, :lumens_per_square_meter => 1.0, :lumen_per_square_metre => 1.0, :lumen_per_square_meter => 1.0,
      :phot => 1.0*10**4, :phots => 1.0*10**4, :ph => 1.0*10**4,
      :lumens_per_square_foot => 10.76391, :footcandle => 10.76391, :lumen_per_square_foot => 10.76391, :footcandles => 10.76391
    },
   :inductance => {
      :henry => 1.0, :henrys => 1.0, :H => 1.0,
      :abhenrys => 1.0*10**-9, :emus_of_inductance => 1.0*10**-9, :abhenry => 1.0*10**-9, :emu_of_inductance => 1.0*10**-9,
      :stathenrys => 8.987552*10**11, :esus_of_inductance => 8.987552*10**11, :stathenry => 8.987552*10**11, :esu_of_inductance => 8.987552*10**11
    },
    :information_storage => {
      :bit => 1.0, :bits => 1.0, :b => 1.0,
      :byte => 8.0, :bytes => 8.0, 
      :nibbles => 4.0, :nybbles => 4.0
    },
    :luminous_flux => {
      :lumen => 1.0, :lumens => 1.0, :lm => 1.0
    },
    :luminous_intensity => {
      :candela => 1.0, :candelas => 1.0, :cd => 1.0
    },
    :magnetic_flux => {
      :webers => 1.0, :Wb => 1.0,
      :maxwells => 1.0*10**-8, :Mx => 1.0*10**-8,
      :unit_poles => 1.256637*10**-7
    },
    :magnetic_inductance => {
      :tesla => 1.0, :teslas => 1.0, :T => 1.0,
      :gamma => 1.0*10**-9, :gammas => 1.0*10**-9,
      :gauss => 1.0*10**-4, :Gs => 1.0*10**-4, :G => 1.0*10**-4
    },
    :mass => {
      :gram => 1.0, :gramme => 1.0, :grams => 1.0, :grammes => 1.0, :g => 1.0,
      :carat => 2.0*10**-1, :carats => 2.0*10**-1,
      :ounce => 2.834952*10**1, :ounces => 2.834952*10**1, :oz => 2.834952*10**1,
      :pennyweight => 1.555174, :pennyweights => 1.555174, :dwt => 1.555174,
      :pound => 453.59237, :pounds => 453.59237, :lb => 453.59237, :lbs => 453.59237,
      :troy_pound => 373.2417, :apothecary_pound => 373.2417, :troy_pounds => 373.2417, :apothecary_pounds => 373.2417,
      :slug => 14593.9029, :slugs => 14593.9029,
      :assay_ton => 29.1667, :assay_tons => 29.1667, :AT => 29.1667,
      :metric_ton => 1000000, :metric_tons => 1000000,
      :ton => 907184.74, :tons => 907184.74, :short_tons => 907184.74 
    },
    :power => {
      :watt => 1.0, :watts => 1.0, :W => 1.0,
      :british_thermal_unit_per_hour => 2.928751*10**-1, :british_thermal_units_per_hour => 2.928751*10**-1,
      :it_british_thermal_unit_per_hour => 2.930711*10**-1, :it_british_thermal_units_per_hour => 2.930711*10**-1,
      :british_thermal_unit_per_second => 1.054350*10**3, :british_thermal_units_per_second => 1.054350*10**3,
      :it_british_thermal_unit_per_second => 1.055056*10**3, :it_british_thermal_units_per_second => 1.055056*10**3,
      :calorie_per_minute => 6.973333*10**-2, :calories_per_minute => 6.973333*10**-2,
      :calorie_per_second => 4.184, :calories_per_second => 4.184,
      :erg_per_second => 1.0*10**-7, :ergs_per_second => 1.0*10**-7,
      :foot_pound_force_per_hour => 3.766161*10**-4,
      :foot_pound_force_per_minute => 2.259697*10**-2,
      :foot_pound_force_per_second => 1.355818,
      :horsepower => 7.456999*10**2,
      :boiler_horsepower => 9.80950*10**3,
      :electric_horsepower => 7.46*10**2,
      :metric_horsepower => 7.354988*10**2,
      :uk_horsepower => 7.4570*10**2,
      :water_horsepower => 7.46043*10**2,
      :kilocalorie_per_minute => 6.973333*10, :kilocalories_per_minute => 6.973333*10,
      :kilocalorie_per_second => 4.184*10**3, :kilocalories_per_second => 4.184*10**3,
      :ton_of_refrigeration => 3.516853*10**3, :tons_of_refrigeration => 3.516853*10**3
    },
    :pressure => {
      :pascal => 1.0, :pascals => 1.0, :Pa => 1.0,
      :atmosphere => 1.01325*10**5, :atmospheres => 1.01325*10**5,
      :technical_atmosphere => 9.80665*10**4, :technical_atmospheres => 9.80665*10**4,
      :bar => 1.0*10**5, :bars => 1.0*10**5,
      :centimeter_of_mercury => 1.333224*10**3, :centimeters_of_mercury => 1.333224*10**3,
      :centimeter_of_water => 98.0665, :centimeters_of_water => 98.0665, :gram_force_per_square_centimeter => 98.0665,
      :dyne_per_square_centimeter => 1.0*10**-1, :dynes_per_square_centimeter => 1.0*10**-1,
      :foot_of_mercury => 4.063666*10**4, :feet_of_mercury => 4.063666*10**4,
      :foot_of_water => 2.989067*10**3, :feet_of_water => 2.989067*10**3,
      :inch_of_mercury => 3.386389*10**3, :inches_of_mercury => 3.386389*10**3,
      :inch_of_water =>  2.490889*10**2, :inches_of_water =>  2.490889*10**2,
      :kilogram_force_per_square_centimeter => 9.80665*10**4,
      :kilogram_force_per_square_meter => 9.80665,
      :kilogram_force_per_square_millimeter =>  9.80665*10**6,
      :kip_per_square_inch => 6.894757*10**6, :kips_per_square_inch => 6.894757*10**6, :ksi => 6.894757*10**6,
      :millibar => 1.0*10**2, :mbar => 1.0*10**2, :millibars => 1.0*10**2, :mbars => 1.0*10**2,
      :millimeter_of_mercury => 1.333224*10**2, :millimeters_of_mercury => 1.333224*10**2,
      :millimeter_of_water => 9.80665, :millimeters_of_water => 9.80665,
      :poundal_per_square_foot => 1.488164, :poundals_per_square_foot => 1.488164,
      :pound_force_per_square_foot => 47.88026,
      :pound_force_per_square_inch => 6.894757*10**3, :psi => 6.894757*10**3,
      :torr => 1.333224*10**2, :torrs => 1.333224*10**2
    },
    :radioactivity => {
      :becquerel => 1.0, :becquerels => 1.0, :Bq => 1.0,
      :curie => 3.7*10**10, :curies => 3.7*10**10, :Ci => 3.7*10**10
    },
    :temperature => {
      :kelvin => 1.0, :K => 1.0,
      :celsius => [Proc.new{ |t| t + 273.15 }, Proc.new{ |t| t - 273.15 }], :centrigrade => [Proc.new{ |t| t + 273.15 }, Proc.new{ |t| t - 273.15 }],
      :degree_celsius => [Proc.new{ |t| t + 273.15 }, Proc.new{ |t| t - 273.15 }], :degree_centrigrade => [Proc.new{ |t| t + 273.15 }, Proc.new{ |t| t - 273.15 }],
      :degrees_celsius => [Proc.new{ |t| t + 273.15 }, Proc.new{ |t| t - 273.15 }], :degrees_centrigrade => [Proc.new{ |t| t + 273.15 }, Proc.new{ |t| t - 273.15 }],
      :fahrenheit => [Proc.new{ |t| t * (5.0/9.0) + 459.67 }, Proc.new{ |t| t * (9.0/5.0) - 459.67 }],
      :degree_fahrenheit => [Proc.new{ |t| t * (5.0/9.0) + 459.67 }, Proc.new{ |t| t * (9.0/5.0) - 459.67 }],
      :degrees_fahrenheit => [Proc.new{ |t| t * (5.0/9.0) + 459.67 }, Proc.new{ |t| t * (9.0/5.0) - 459.67 }],
      :rankine => 1.8, :rankines => 1.8
    }, 
    :time => {
      :second => 1.0, :seconds => 1.0, :s => 1.0,
      :minute => 60.0, :minutes => 60.0, :min => 60.0,
      :sidereal_minute => 5.983617, :sidereal_minutes => 5.983617,
      :hour => 3600.0, :hours => 3600.0, :hr => 3600.0,
      :sidereal_hour => 3.590170*10**3, :sidereal_hours => 3.590170*10**3,
      :day => 86400.0, :days => 86400.0,
      :sidereal_day => 8.616409*10**4, :sidereal_days => 8.616409*10**4,
      :shake => 1.0*10**-8, :shakes => 1.0*10**-8,
      :year => 3.1536*10**7, :years => 3.1536*10**7,
      :sidereal_year => 3.155815*10**7, :sidereal_years => 3.155815*10**7,
      :tropical_year => 3.155693*10**7, :tropical_years => 3.155693*10**7
    },
    :volume => {
      :litre => 1.0, :liter => 1.0, :litres => 1.0, :liters => 1.0, :l => 1.0, :L => 1.0,
      :barrel => 1.589873*10**2, :barrels => 1.589873*10**2,
      :bushel => 3.523907*10**1, :bushels => 3.523907*10**1,
      :cubic_meter => 1000.0, :cubic_meters => 1000.0,
      :cup => 2.365882*10**-1, :cups => 2.365882*10**-1,
      :imperial_fluid_ounce => 0.0284130742, :imperial_fluid_ounces => 0.0284130742,
      :ounce => 0.0295735296, :ounces => 0.0295735296, :fluid_ounce => 0.0295735296, :fluid_ounces => 0.0295735296,
      :imperial_gallon => 4.54609, :imperial_gallons => 4.54609,
      :gallon => 3.785412, :gallons => 3.785412,
      :imperial_gill => 1.420653*10**-1, :imperial_gills => 1.420653*10**-1,
      :gill => 1.182941*10**-1, :gills => 1.182941*10**-1, :gi => 1.182941*10**-1,
      :pint => 5.506105*10**-1, :pints => 5.506105*10**-1,
      :liquid_pint => 4.731765*10**-1, :liquid_pints => 4.731765*10**-1,
      :quart => 1.101221, :quarts => 1.101221,
      :liquid_quart => 9.463529*10**-1, :liquid_quarts => 9.463529*10**-1,
      :tablespoon => 0.0147867648, :tablespoons => 0.0147867648,
      :teaspoon => 0.00492892159, :teaspoons => 0.00492892159
    }
  }
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
  
  def from(unit_name)
    send(unit_name)
  end
  
  def self.british_standard_unit_prefixes
    @@british_standard_unit_prefixes
  end
  
  def self.conversion_table
    @@conversion_table
  end
  
  class NumericConversion
    def to(type = nil)
      unless type
        self 
      else
        send(type)
      end
    end
    alias_method :as, :to
    
    def base(unit_type)
      if(Alchemist.conversion_table[unit_type][@unit_name].is_a?(Array))
        @exponent * Alchemist.conversion_table[unit_type][@unit_name][0].call(@value)
      else
        @exponent * @value * Alchemist.conversion_table[unit_type][@unit_name]
      end
    end
    
    def to_s
      @value.to_s
    end
    
    def to_f
      @value
    end
    
    private 
    def initialize value, unit_name, exponent = 1.0
      @value = value.to_f
      @unit_name = unit_name
      @exponent = exponent
    end
    
    def method_missing unit_name, *args, &block
      exponent, unit_name = Alchemist.parse_prefix(unit_name)
      if Conversions[ unit_name ]  
        types = Conversions[ @unit_name] & Conversions[ unit_name]
        if types[0] # assume first type
          if(Alchemist.conversion_table[types[0]][unit_name].is_a?(Array))
            Alchemist.conversion_table[types[0]][unit_name][1].call(base(types[0]))
          else
            NumericConversion.new(base(types[0]) / (exponent * Alchemist.conversion_table[types[0]][unit_name]), unit_name)
          end
        else
          raise Exception, "Incompatible Types"
        end
      else
        args.map!{|a| a.is_a?(NumericConversion) ? a.send(@unit_name).to_f / @exponent : a }
        @value = @value.send( unit_name, *args, &block )
        self
      end
    end
  end
  
  Conversions = {}
  def method_missing unit_name, *args, &block
    exponent, unit_name = Alchemist.parse_prefix(unit_name)
    Conversions[ unit_name ] || super( unit_name, *args, &block )
    NumericConversion.new self, unit_name, exponent
  end
  
  def self.parse_prefix(unit)
    @@british_standard_unit_prefixes.each do |prefix, value|
      if unit.to_s =~ /^#{prefix}.+/ && @@si_units.include?(unit.to_s.gsub(/^#{prefix}/,''))        
        return [value, unit.to_s.gsub(/^#{prefix}/,'').to_sym]
      end
    end
    [1.0, unit]
  end
  
  @@conversion_table.each do |type, conversions|
    conversions.each do |name, value|
      Conversions[name] ||= []
      Conversions[name] << type
    end
  end
end

class Numeric
  include Alchemist
end