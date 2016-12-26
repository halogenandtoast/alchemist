Alchemist
=========

[![Build Status](https://travis-ci.org/halogenandtoast/alchemist.png?branch=master)](https://travis-ci.org/halogenandtoast/alchemist)
[![Code Climate](https://codeclimate.com/github/halogenandtoast/alchemist.png)](https://codeclimate.com/github/halogenandtoast/alchemist)

Doing conversions for you so you don’t have to google them and making
code more readable.

Having code that looks like this is meaningless

```ruby
meters = 8 * 1609.344
```

You could add comments

```ruby
meters = 8 * 1609.344 # converting miles to meters
```

But why not have this!

```ruby
8.miles.to.meters
```

You can even perform mathematical operations

```ruby
10.kilometers + 1.mile # 11.609344 kilometers
```

Handling bytes now works according to the JEDEC memory standard

```ruby
1.kb.to.b.to_f == 1024.0
```

Converting distance of arc length on Earth to an (approximate) corresponding spherical geometry angle can be done with

```ruby
require 'alchemist/geospatial'
1.mile.geospatial.to.degree == 0.014457066992474555
```

To switch to the IEC memory standard, force SI units with

```ruby
Alchemist.config.use_si = true
```

To see all the units alchemist has built in conversion for, check out the [units file](lib/alchemist/data/units.yml)

<strong>You may also register your own units</strong>

```ruby
Alchemist.register(:distance, [:beard_second, :beard_seconds], 5.angstroms)
```

Installation
------------

    gem install alchemist

Setup
-----

In order for methods like `1.meter` to work, you'll either need to setup Alchemist yourself:

```ruby
Alchemist.setup # This will load every category of measurement
```

if you only want to use one category for conversions you can load it individually:

```ruby
Alchemist.setup('distance') # This will load only distance
```

Rails
-----

#### Setup

It is suggested that you add your `Alchemist.setup` call to `config/initializers/alchemist.rb` and then restart your rails server.


#### Rails Warning

Rails adds some methods like `bytes` to `Numeric` so it's highly recommended that instead of trying to call `bytes` on a numeric, you should use the `measure` method:

```ruby
Alchemist.measure(10, :bytes)
```

License
-------

Alchemist is licensed under the MIT license as specified in the [gemspec](alchemist.gemspec)
