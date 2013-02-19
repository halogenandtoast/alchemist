module Alchemist
  def self.unit_prefixes
    {
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
  end
end
