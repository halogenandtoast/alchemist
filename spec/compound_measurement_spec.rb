require 'spec_helper'

module Alchemist
  describe CompoundMeasurement do
    it "can handle compound units" do
      expect(30.miles).to eq(10.miles.per.second * 3.seconds)
    end

    it "can handle elimination of a unit" do
      expect(4.m.per.m).to eq(4)
    end

    it "can multiply a coefficient" do
      expect(10.miles.per.second * 3).to eq(30.miles.per.second)
    end

    it "considers units different by coefficient" do
      expect(10.miles.per.second).not_to eq(30.miles.per.second)
    end

    it "considers unit different by numerators" do
      expect(10.miles.per.second).not_to eq(10.feet.per.second)
    end

    it "considers unit different by denominators" do
      expect(10.miles.per.second).not_to eq(10.miles.per.minutes)
    end
  end
end
