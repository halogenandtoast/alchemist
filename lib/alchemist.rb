module Alchemist
  @use_si = false
  class << self
    attr_accessor :use_si
  end
  
  @@si_units = %w[m meter metre meters metres liter litre litres liters l L farad farads F coulombs C gray grays Gy siemen siemens S mhos mho ohm ohms volt volts V ]
  @@si_units += %w[joule joules J newton newtons N lux lx henry henrys H b B bits bytes bit byte lumen lumens lm candela candelas cd]
  @@si_units += %w[tesla teslas T gauss Gs G gram gramme grams grammes g watt watts W pascal pascals Pa]
  @@si_units += %w[becquerel becquerels Bq curie curies Ci]
  @@operator_actions = {}
  @@conversion_table = {
    :absorbed_radiation_dose => {
      :gray => 1.0, :grays => 1.0, :Gy => 1.0,
      :rad => 1.0e-2, :rads => 1.0e-2
    },
    :angles => {
      :radian => 1.0, :radians => 1.0,
      :degree => Math::PI / 180.0, :degrees => Math::PI / 180.0,
      :arcminute => Math::PI / 10800.0, :arcminutes => Math::PI / 10800.0,
      :arcsecond => Math::PI / 648000.0, :arcseconds => Math::PI / 648000.0,
      :mil => 9.817477e-4, :mils => 9.817477e-4,
      :revolution => Math::PI * 2.0, :revolutions => Math::PI * 2.0,
      :circle =>  Math::PI * 2.0, :circles =>  Math::PI * 2.0,
      :right_angle =>  Math::PI / 2.0, :right_angles =>  Math::PI / 2.0,
      :grad => Math::PI / 200.0, :grade => Math::PI / 200.0, :gradian => Math::PI / 200.0, :gon => Math::PI / 200.0, :grads => Math::PI / 200.0, :grades => Math::PI / 200.0, :gradians => Math::PI / 200.0, :gons => Math::PI / 200.0,
      #unusual measurements
      :furman => 9.58737992858887e-5, :furmans => 9.58737992858887e-5
    },
    :area => {
      :square_meter => 1.0, :square_meters => 1.0, :square_metre => 1.0, :square_metres => 1.0,
      :acre => 4046.85642, :acres => 4046.85642, 
      :are => 1.0e+2, :ares => 1.0e+2, :a => 1.0e+2,
      :barn => 1.0e-28, :barns => 1.0e-28, :b => 1.0e-28,
      :circular_mil => 5.067075e-10, :circular_mils => 5.067075e-10,
      :hectare => 1.0e+4, :hectares => 1.0e+4, :ha => 1.0e+4,
      :square_foot => 9.290304e-2, :square_feet => 9.290304e-2,
      :square_inch => 6.4516e-4, :square_inches => 6.4516e-4,
      :square_mile => 2.589988e+6, :square_miles => 2.589988e+6,
      :square_yard => 0.83612736, :square_yards => 0.83612736
    },
    :capacitance => {
      :farad => 1.0, :farads => 1.0, :F => 1.0,
      :abfarad => 1.0e+9, :emu_of_capacitance => 1.0e+9, :abfarads => 1.0e+9, :emus_of_capacitance => 1.0e+9,
      :statfarad => 1.112650e-12, :esu_of_capacitance => 1.112650e-12, :statfarads => 1.112650e-12, :esus_of_capacitance => 1.112650e-12
    },
    :density => {
      :specific_gravity => 1, :sg => 1,
      :brix     => [Proc.new{ |d| -261.3 / (d - 261.3) }, Proc.new{ |d| 261.3 - (261.3 / d) }],
      :plato    => [Proc.new{ |d| -260.0 / (d - 260.0) }, Proc.new{ |d| 260.0 - (260.0 / d) }],
      :baume    => [Proc.new{ |d| -145.0 / (d - 145.0) }, Proc.new{ |d| 145.0 - (145.0 / d) }]
    },
    :distance => {
      :meter => 1.0, :metres => 1.0, :meters => 1.0, :m => 1.0,
      :fermi => 1.0e-15, :fermis => 1.0e-15,
      :micron => 1.0e-6, :microns => 1.0e-6,
      :chain => 20.1168, :chains => 20.1168,
      :inch => 25.4e-3, :inches => 25.4e-3, :in => 25.4e-3,
      :microinch => 2.54e-8, :microinches => 2.54e-8,
      :mil => 2.54e-05, :mils => 2.54e-05,
      :rod => 5.029210, :rods => 5.029210,
      :league => 5556, :leagues => 5556,
      :foot => 0.3048, :feet => 0.3048, :ft => 0.3048,
      :yard => 0.9144, :yards => 0.9144, :yd => 0.9144,
      :mile =>1609.344, :miles =>1609.344, :mi => 1609.344,
      :astronomical_unit => 149.60e+9, :astronomical_units => 149.60e+9, :au => 149.60e+9, :ua => 149.60e+9,
      :light_year => 9.461e+15, :light_years => 9.461e+15, :ly => 9.461e+15,
      :parsec => 30.857e+15, :parsecs => 30.857e+15,
      :nautical_mile => 1852.0, :nautical_miles => 1852.0,
      :admirality_mile => 185.3184, :admirality_miles => 185.3184,
      :fathom => 1.8288, :fathoms => 1.8288,
      :cable_length => 185.2, :cable_lengths => 185.2,
      :angstrom => 100.0e-12, :angstroms => 100.0e-12,
      :pica => 4.233333e-3, :picas => 4.233333e-3,
      :printer_pica => 4.217518e-3, :printer_picas => 4.217518e-3,
      :point => 3.527778e-4, :points => 3.527778e-4,
      :printer_point => 3.514598e-4, :printer_points => 3.514598e-4,
      # unusual mesaurements
      :empire_state_building => 449.0, :empire_state_buildings => 449.0,
      :sears_tower => 519.0, :sears_towers => 519.0,
      :seattle_space_needle => 184.0, :seattle_space_needles => 184.0, :space_needle => 184.0, :space_needles => 184.0,
      :statue_of_liberty => 46.0, :statue_of_liberties => 46.0,
      :washington_monument => 169.294, :washington_monuments => 169.294,
      :eiffel_tower => 324.0, :eiffel_towers => 324.0,
      :nelsons_column => 61.5, :nelsons_columns => 61.5,
      :blackpool_tower => 158.0, :blackpool_towers => 158.0,
      :big_ben => 96.3, :big_bens => 96.3, :clock_tower_of_the_palace_of_westminster => 96.3, :clock_towers_of_the_palace_of_westminster => 96.3,
      :st_pauls_cathedral => 108.0, :st_pauls_cathedrals => 108.0,
      :toronto_cn_tower => 553.0, :toronto_cn_towers => 553.0, :cn_tower => 553.0, :cn_towers => 553.0,
      :circle_of_the_earth => 40075016.686, :equator => 40075016.686, :circles_of_the_earth => 40075016.686, :equators => 40075016.686,
      :siriometer => 1.494838e+17, :siriometers => 1.494838e+17,
      :football_field => 91.0, :football_fields => 91.0,
      :length_of_a_double_decker_bus => 8.4, :height_of_a_double_decker_bus => 4.4,
      :smoot => 1.7018, :smoots => 1.7018
    },
    :dose_equivalent => {
      :sievert => 1.0, :sieverts => 1.0, :Si => 1.0,
      :rem => 1.0e-2, :rems => 1.0e-2
    },
    :electric_charge => {
      :coulomb => 1.0, :coulombs => 1.0, :C => 1.0,
      :abcoulomb => 10.0, :abcoulombs => 10.0,
      :ampere_hour => 3.6e+3, :ampere_hours => 3.6e+3,
      :faraday => 9.648534e+4, :faradays => 9.648534e+4,
      :franklin => 3.335641e-10, :franklins => 3.335641e-10, :Fr => 3.335641e-10,
      :statcoulomb => 3.335641e-10, :statcoulombs => 3.335641e-10
    },
    :electric_conductance => {
      :siemen => 1.0, :siemens => 1.0, :S => 1.0, :mho => 1.0,
      :abmho => 1.0e+9, :absiemen => 1.0e+9, :absiemens => 1.0e+9,
      :statmho => 1.112650e-12, :statsiemen => 1.112650e-12, :statsiemens => 1.112650e-12
    },
    :electrical_impedance => {
      :ohm => 1.0, :ohms => 1.0,
      :abohm => 1.0e-9, :emu_of_resistance => 1.0e-9, :abohms => 1.0e-9, :emus_of_resistance => 1.0e-9,
      :statohm => 8.987552e+11, :esu_of_resistance => 8.987552e+11, :statohms => 8.987552e+11, :esus_of_resistance => 8.987552e+11
    },
    :electromotive_force => {
      :volt => 1.0, :volts => 1.0, :V => 1.0,
      :abvolt => 1.0e-8, :emu_of_electric_potential => 1.0e-8, :abvolts => 1.0e-8, :emus_of_electric_potential => 1.0e-8,
      :statvolt => 2.997925e+2, :esu_of_electric_potential => 2.997925e+2, :statvolts => 2.997925e+2, :esus_of_electric_potential => 2.997925e+2
    },
    :energy => {
      :joule => 1.0, :joules => 1.0, :J => 1.0, :watt_second => 1.0, :watt_seconds => 1.0,
      :watt_hour => 3.6e+3, :watt_hours => 3.6e+3,
      :ton_of_tnt => 4.184e+9, :tons_of_tnt => 4.184e+9,
      :therm => 1.05506e+8, :therms => 1.05506e+8,
      :us_therm => 1.054804e+8, :us_therms => 1.054804e+8,
      :kilowatt_hour => 3.6e+6, :kilowatt_hours => 3.6e+6,
      :kilocalorie => 4184.0, :kilocalories => 4184.0,
      :calorie => 4.184, :calories => 4.184,
      :mean_kilocalorie => 4190, :mean_kilocalories => 4190,
      :mean_calorie => 4.190, :mean_calories => 4.190,
      :it_kilocalorie => 4186.8, :it_kilocalories => 4186.8,
      :it_calorie => 4.1868, :it_calories => 4.1868,
      :foot_poundal => 4.214011e-2, :foot_poundals => 4.214011e-2,
      :foot_pound_force => 1.355818,
      :erg =>  1.0e-7, :ergs =>  1.0e-7,
      :electronvolt => 1.602176e-19, :electronvolts => 1.602176e-19, :eV => 1.602176e-19,
      :british_thermal_unit => 1.054350e+3, :british_thermal_units => 1.054350e+3,
      :mean_british_thermal_unit => 1.05587e+3, :mean_british_thermal_units => 1.05587e+3,
      :it_british_thermal_unit => 1.055056e+3, :it_british_thermal_units => 1.055056e+3,
      #unusual measurements
      :foe => 1e+44, :foes => 1e+44
    },
    :force => {
      :newton => 1.0, :newtons => 1.0, :N => 1.0,
      :dyne => 1.0e-5, :dynes => 1.0e-5, :dyn => 1.0e-5,
      :kilogram_force => 9.80665, :kgf => 9.80665, :kilopond => 9.80665, :kiloponds => 9.80665, :kp => 9.80665,
      :kip => 4.448222e+3, :kips => 4.448222e+3,
      :ounce_force => 2.780139e-1, :ozf => 2.780139e-1,
      :poundal => 1.382550e-1, :poundals => 1.382550e-1,
      :pound_force => 4.448222, :lbf => 4.448222,
      :ton_force => 8.896443e+3
    },
    :illuminance => {
      :lux => 1.0, :lx => 1.0, :lumens_per_square_metre => 1.0, :lumens_per_square_meter => 1.0, :lumen_per_square_metre => 1.0, :lumen_per_square_meter => 1.0,
      :phot => 1.0e+4, :phots => 1.0e+4, :ph => 1.0e+4,
      :lumens_per_square_foot => 10.76391, :footcandle => 10.76391, :lumen_per_square_foot => 10.76391, :footcandles => 10.76391
    },
   :inductance => {
      :henry => 1.0, :henrys => 1.0, :H => 1.0,
      :abhenrys => 1.0e-9, :emus_of_inductance => 1.0e-9, :abhenry => 1.0e-9, :emu_of_inductance => 1.0e-9,
      :stathenrys => 8.987552e+11, :esus_of_inductance => 8.987552e+11, :stathenry => 8.987552e+11, :esu_of_inductance => 8.987552e+11
    },
    :information_storage => {
      :bit => 1.0, :bits => 1.0, :b => 1.0,
      :byte => 8.0, :bytes => 8.0, :B => 8.0,
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
      :maxwells => 1.0e-8, :Mx => 1.0e-8,
      :unit_poles => 1.256637e-7
    },
    :magnetic_inductance => {
      :tesla => 1.0, :teslas => 1.0, :T => 1.0,
      :gamma => 1.0e-9, :gammas => 1.0e-9,
      :gauss => 1.0e-4, :Gs => 1.0e-4, :G => 1.0e-4
    },
    :mass => {
      :gram => 1.0, :gramme => 1.0, :grams => 1.0, :grammes => 1.0, :g => 1.0,
      :carat => 2.0e-1, :carats => 2.0e-1,
      :ounce => 2.834952e+1, :ounces => 2.834952e+1, :oz => 2.834952e+1,
      :pennyweight => 1.555174, :pennyweights => 1.555174, :dwt => 1.555174,
      :pound => 453.59237, :pounds => 453.59237, :lb => 453.59237, :lbs => 453.59237,
      :troy_pound => 373.2417, :apothecary_pound => 373.2417, :troy_pounds => 373.2417, :apothecary_pounds => 373.2417,
      :slug => 14593.9029, :slugs => 14593.9029,
      :assay_ton => 29.1667, :assay_tons => 29.1667, :AT => 29.1667,
      :metric_ton => 1000000, :metric_tons => 1000000,
      :ton => 907184.74, :tons => 907184.74, :short_tons => 907184.74,
      #unusual measurements
      :elephant => 5443108.44, :elephants => 5443108.44
    },
    :power => {
      :watt => 1.0, :watts => 1.0, :W => 1.0,
      :british_thermal_unit_per_hour => 2.928751e-1, :british_thermal_units_per_hour => 2.928751e-1,
      :it_british_thermal_unit_per_hour => 2.930711e-1, :it_british_thermal_units_per_hour => 2.930711e-1,
      :british_thermal_unit_per_second => 1.054350e+3, :british_thermal_units_per_second => 1.054350e+3,
      :it_british_thermal_unit_per_second => 1.055056e+3, :it_british_thermal_units_per_second => 1.055056e+3,
      :calorie_per_minute => 6.973333e-2, :calories_per_minute => 6.973333e-2,
      :calorie_per_second => 4.184, :calories_per_second => 4.184,
      :erg_per_second => 1.0e-7, :ergs_per_second => 1.0e-7,
      :foot_pound_force_per_hour => 3.766161e-4,
      :foot_pound_force_per_minute => 2.259697e-2,
      :foot_pound_force_per_second => 1.355818,
      :horsepower => 7.456999e+2,
      :boiler_horsepower => 9.80950e+3,
      :electric_horsepower => 7.46e+2,
      :metric_horsepower => 7.354988e+2,
      :uk_horsepower => 7.4570e+2,
      :water_horsepower => 7.46043e+2,
      :kilocalorie_per_minute => 6.973333*10, :kilocalories_per_minute => 6.973333*10,
      :kilocalorie_per_second => 4.184e+3, :kilocalories_per_second => 4.184e+3,
      :ton_of_refrigeration => 3.516853e+3, :tons_of_refrigeration => 3.516853e+3
    },
    :pressure => {
      :pascal => 1.0, :pascals => 1.0, :Pa => 1.0,
      :atmosphere => 1.01325e+5, :atmospheres => 1.01325e+5,
      :technical_atmosphere => 9.80665e+4, :technical_atmospheres => 9.80665e+4,
      :bar => 1.0e+5, :bars => 1.0e+5,
      :centimeter_of_mercury => 1.333224e+3, :centimeters_of_mercury => 1.333224e+3,
      :centimeter_of_water => 98.0665, :centimeters_of_water => 98.0665, :gram_force_per_square_centimeter => 98.0665,
      :dyne_per_square_centimeter => 1.0e-1, :dynes_per_square_centimeter => 1.0e-1,
      :foot_of_mercury => 4.063666e+4, :feet_of_mercury => 4.063666e+4,
      :foot_of_water => 2.989067e+3, :feet_of_water => 2.989067e+3,
      :inch_of_mercury => 3.386389e+3, :inches_of_mercury => 3.386389e+3,
      :inch_of_water =>  2.490889e+2, :inches_of_water =>  2.490889e+2,
      :kilogram_force_per_square_centimeter => 9.80665e+4,
      :kilogram_force_per_square_meter => 9.80665,
      :kilogram_force_per_square_millimeter =>  9.80665e+6,
      :kip_per_square_inch => 6.894757e+6, :kips_per_square_inch => 6.894757e+6, :ksi => 6.894757e+6,
      :millibar => 1.0e+2, :mbar => 1.0e+2, :millibars => 1.0e+2, :mbars => 1.0e+2,
      :millimeter_of_mercury => 1.333224e+2, :millimeters_of_mercury => 1.333224e+2,
      :millimeter_of_water => 9.80665, :millimeters_of_water => 9.80665,
      :poundal_per_square_foot => 1.488164, :poundals_per_square_foot => 1.488164,
      :pound_force_per_square_foot => 47.88026,
      :pound_force_per_square_inch => 6.894757e+3, :psi => 6.894757e+3,
      :torr => 1.333224e+2, :torrs => 1.333224e+2
    },
    :radioactivity => {
      :becquerel => 1.0, :becquerels => 1.0, :Bq => 1.0,
      :curie => 3.7e+10, :curies => 3.7e+10, :Ci => 3.7e+10
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
    }, 
    :time => {
      :second => 1.0, :seconds => 1.0, :s => 1.0,
      :minute => 60.0, :minutes => 60.0, :min => 60.0,
      :sidereal_minute => 5.983617, :sidereal_minutes => 5.983617,
      :hour => 3600.0, :hours => 3600.0, :hr => 3600.0, :h => 3600.0,
      :sidereal_hour => 3.590170e+3, :sidereal_hours => 3.590170e+3,
      :day => 86400.0, :days => 86400.0,
      :sidereal_day => 8.616409e+4, :sidereal_days => 8.616409e+4,
      :shake => 1.0e-8, :shakes => 1.0e-8,
      :year => 3.1536e+7, :years => 3.1536e+7,
      :sidereal_year => 3.155815e+7, :sidereal_years => 3.155815e+7,
      :tropical_year => 3.155693e+7, :tropical_years => 3.155693e+7,
      #unusual measurements
      :jiffy => 0.01, :jiffies => 0.01,
      :microfortnight => 1.2096, :microfortnights => 1.2096,
      :megaannum => 3.1536e+16, :Ma => 3.1536e+16, :megaannums => 3.1536e+16,
      :galactic_year => 7.884e+18, :galactic_years => 7.884e+18, :GY => 7.884e+18
    },
    :volume => {
      :litre => 1.0, :liter => 1.0, :litres => 1.0, :liters => 1.0, :l => 1.0, :L => 1.0,
      :barrel => 1.589873e+2, :barrels => 1.589873e+2,
      :bushel => 3.523907e+1, :bushels => 3.523907e+1,
      :cubic_meter => 1000.0, :cubic_meters => 1000.0,
      :cup => 2.365882e-1, :cups => 2.365882e-1,
      :imperial_fluid_ounce => 0.0284130742, :imperial_fluid_ounces => 0.0284130742,
      :ounce => 0.0295735296, :ounces => 0.0295735296, :fluid_ounce => 0.0295735296, :fluid_ounces => 0.0295735296,
      :imperial_gallon => 4.54609, :imperial_gallons => 4.54609,
      :gallon => 3.785412, :gallons => 3.785412,
      :imperial_gill => 1.420653e-1, :imperial_gills => 1.420653e-1,
      :gill => 1.182941e-1, :gills => 1.182941e-1, :gi => 1.182941e-1,
      :pint => 5.506105e-1, :pints => 5.506105e-1,
      :liquid_pint => 4.731765e-1, :liquid_pints => 4.731765e-1,
      :quart => 1.101221, :quarts => 1.101221,
      :liquid_quart => 9.463529e-1, :liquid_quarts => 9.463529e-1,
      :tablespoon => 0.0147867648, :tablespoons => 0.0147867648,
      :teaspoon => 0.00492892159, :teaspoons => 0.00492892159,
      #unusual measurements
      :sydharb => 5.0e+11, :sydharbs => 5.0e+11
    }
  }
  @@unit_prefixes = {
    :googol => 1e+100,
    :yotta => 1e+24, :Y => 1e+24,
    :zetta => 1e+21, :Z => 1e+21,
    :exa => 1e+18, :E => 1e+18,
    :peta => 1e+15, :P => 1e+15,
    :tera => 1e+12, :T => 1e+12,
    :giga => 1e+9, :G => 1e+9,
    :mega => 1e+6, :M => 1e+6,
    :kilo => 1e+3, :k => 1e+3,
    :hecto => 1e+2, :h => 1e+2,
    :deca => 10, :da => 10,
    :deci => 1e-1, :d => 1e-1,
    :centi => 1e-2, :c => 1e-2,
    :milli => 1e-3, :m => 1e-3,
    :micro => 1e-6, :u => 1e-6,
    :nano => 1e-9, :n => 1e-9,
    :pico => 1e-12, :p => 1e-12,
    :femto => 1e-15, :f => 1e-15,
    :atto => 1e-18, :a => 1e-18,
    :zepto => 1e-21, :z => 1e-21,
    :yocto => 1e-24, :y => 1e-24,
    
    # binary prefixes
    
    :kibi => 2.0**10.0, :Ki => 2.0**10.0,
    :mebi => 2.0**20.0, :Mi => 2.0**20.0,
    :gibi => 2.0**30.0, :Gi => 2.0**30.0,
    :tebi => 2.0**40.0, :Ti => 2.0**40.0,
    :pebi => 2.0**50.0, :Pi => 2.0**50.0,
    :exbi => 2.0**60.0, :Ei => 2.0**60.0,
    :zebi => 2.0**70.0, :Zi => 2.0**70.0,
    :yobi => 2.0**80.0, :Yi => 2.0**80.0
  }
  
  def from(unit_name)
    send(unit_name)
  end
  
  def self.unit_prefixes
    @@unit_prefixes
  end
  
  def self.conversion_table
    @@conversion_table
  end
  
  def self.operator_actions
    @@operator_actions
  end
  
  class CompoundNumericConversion
    attr_accessor :numerators, :denominators
    def initialize(numerator)
      @coefficient = 1 #* numerator.to_f
      @numerators = [numerator]
      @denominators = []
    end
    def *(value)
      case value
      when Numeric 
         @coefficient *= value
         self
      when Alchemist::NumericConversion
        @numerators << value
        return consolidate
      end
    end
    
    def consolidate
      @numerators.each_with_index do |numerator, n|
        @denominators.each_with_index do |denominator, d|
          next if numerator.is_a?(Numeric)
          next if denominator.is_a?(Numeric)
          if (Conversions[numerator.unit_name] & Conversions[denominator.unit_name]).length > 0
            value = numerator / denominator
            @numerators.delete_at(n)
            @denominators.delete_at(d)
            @coefficient *= value
          end
        end
      end
      if @denominators.length == 0 && @numerators.length == 1
        @numerators[0] * @coefficient
      elsif @denominators.length == 0 && @numerators.length == 0
        @coefficient
      else
        self
      end
    end
    
    def to_s
      
    end
    
    def method_missing(method, *attrs, &block)
      if Conversions[method]
        @denominators << 1.send(method)
        consolidate
      end
    end
  end
  
  class NumericConversion
    include Comparable
    
    def per
      Alchemist::CompoundNumericConversion.new(self)
    end
    
    def p
      per
    end
    
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
    
    def unit_name
      @unit_name
    end
    
    def to_s
      @value.to_s
    end
    
    def value
      @value
    end
    
    def to_f
      @value
    end
    
    def ==(other)
      self <=> other
    end
    
    def <=>(other)
      (self.to_f * @exponent).to_f <=> other.to(@unit_name).to_f
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
        if args[0] && args[0].is_a?(NumericConversion) && Alchemist.operator_actions[unit_name]
          t1 = Conversions[ @unit_name ][0]
          t2 = Conversions[ args[0].unit_name ][0]
          Alchemist.operator_actions[unit_name].each do |s1, s2, new_type|
            if t1 == s1 && t2 == s2
              return (@value * args[0].to_f).send(new_type)
            end
          end
        end
        if unit_name == :*
          if args[0].is_a?(Numeric)
            @value *= args[0]
            return self
          else
            raise Exception, "Incompatible Types"
          end
        end
        if unit_name == :/ && args[0].is_a?(NumericConversion)
          raise Exception, "Incompatible Types" unless (Conversions[@unit_name] & Conversions[args[0].unit_name]).length > 0  
        end
        args.map!{|a| a.is_a?(NumericConversion) ? a.send(@unit_name).to_f / @exponent : a }
        @value = @value.send( unit_name, *args, &block )
        
        
        unit_name == :/ ? @value : self
      end
    end
  end
  
  Conversions = {}
  def method_missing unit_name, *args, &block
    exponent, unit_name = Alchemist.parse_prefix(unit_name)
    Conversions[ unit_name ] || super( unit_name, *args, &block )
    NumericConversion.new self, unit_name, exponent
  end
  
  def self.register(type, names, value)
    names = [names] unless names.is_a?(Array)
    value = value.is_a?(NumericConversion) ? value.base(type) : value
    names.each do |name|
      Conversions[name] ||= []
      Conversions[name] << type
      Alchemist.conversion_table[type][name] = value
    end
  end

	def self.register_operation_conversions type, other_type, operation, converted_type
	  @@operator_actions[operation] ||= []
    @@operator_actions[operation] << [type, other_type, converted_type]
	end
  
  def self.parse_prefix(unit)
    @@unit_prefixes.each do |prefix, value|
      if unit.to_s =~ /^#{prefix}.+/ && @@si_units.include?(unit.to_s.gsub(/^#{prefix}/,''))        
        if !(Conversions[ unit.to_s.gsub(/^#{prefix}/,'').to_sym ] & [ :information_storage ]).empty? && !@use_si && value >= 1000.0 && value.to_i & -value.to_i != value
          value = 2 ** (10 * (Math.log(value) / Math.log(10)) / 3)
        end
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

require 'alchemist/compound'