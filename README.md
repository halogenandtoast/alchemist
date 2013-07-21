Alchemist
=========

[![Build Status](https://travis-ci.org/halogenandtoast/alchemist.png?branch=master)](https://travis-ci.org/halogenandtoast/alchemist)
[![Code Climate](https://codeclimate.com/github/halogenandtoast/alchemist.png)](https://codeclimate.com/github/halogenandtoast/alchemist)

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

To see all the units alchemist has built in conversion for, check out the [units file](lib/alchemist/data/units.yml)

<strong>You may also register your own units</strong>

    Alchemist.register(:distance, [:beard_second, :beard_seconds], 5.angstroms)

Installation
------------

    gem install alchemist

Setup
-----

In order for methods like `1.meter` to work, you'll either need to include the `Alchemist::Conversion` module in `Numeric` yourself like so:

    class Numeric
      include Alchemist::Conversion
    end

or you can just call:

    Alchemist.setup

if you only want to use one category for conversions you can load it individually (this will prevent method_missing from being overridden):

    Alchemist.setup('distance')

Rails Warning
-------------

Rails adds some methods like `bytes` to `Numeric` so it's highly recommended that instead of trying to call `bytes` on a numeric, you should use the `measurement` method:

    Alchemist.measurement(10, :bytes)

License
-------

Alchemist is licensed under the MIT license as specified in the [gemspec](alchemist.gemspec)
