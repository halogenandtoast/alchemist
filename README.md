Alchemist
=========

Doing conversions for you so you don’t have to google them and making
code more readable.

Having code that looks like this is meaningless

    miles = 8 * 1609.344

You could add comments

    miles = 8 * 1609.344 # converting meters to miles

But why not have this!

    8.meters.to.miles

You can even perform mathematical operations

    10.kilometers + 1.mile # 11.609344 kilometers

Handling bytes now works according to the JEDEC memory standard

    1.kb.to.b.to_f == 1024.0

To switch to the IEC memory standard, force SI units with

    Alchemist::use_si = true

<strong>You may also register your own units</strong>

    Alchemist.register(:distance, [:beard_second, :beard_seconds], 5.angstroms)

Thanks to <a href='http://github.com/simonmenke'>simonmenke</a> you can
now do comparisons without having to convert to floats like so:

    5.grams == 0.005.kilograms

Installation
------------

    gem install alchemist

Usage
-----

    require 'rubygems'
    require 'alchemist'

Or if you’re using rails

    gem 'alchemist'

Alchemist has conversions for:
------------------------------

### Distance

-   metres or meters
-   fermis
-   microns
-   chains
-   inches
-   microinches
-   mils
-   rods
-   leagues
-   feet
-   yards
-   miles
-   astronomical\_units
-   light\_years
-   parsecs
-   nautical\_miles
-   admirality\_miles
-   fathoms
-   cable\_lengths
-   angstroms
-   picas
-   printer\_picas
-   points
-   printer\_points

### Mass

-   grams or grammes
-   carats
-   ounces
-   pennyweights
-   pounds
-   troy\_pounds or apothecary\_pounds
-   slugs
-   assay\_tons
-   metric\_tons
-   tons or short\_tons

### Volume

-   litres or liters
-   barrels
-   bushels
-   cubic\_meters
-   cups
-   imperial\_fluid\_ounces
-   fluid\_ounces
-   imperial\_gallons
-   gallons
-   imperial\_gills
-   gills
-   pints
-   liquid\_pints
-   quarts
-   liquid\_quarts
-   tablespoons
-   teaspoons

### And many more checkout **lib/alchemist.rb** for the rest
