require 'spec_helper'

module Alchemist
  describe Measurement do
    it "can multiply units" do
      expect(2.meters * 3).to eq(6.meters)
    end

    it "can divide units" do
      expect(4.meters / 2).to eq(2.meters)
    end

    it "can add units" do
      expect(2.meters + 1.meter).to eq(3.meters)
    end

    it "can subtract units" do
      expect(3.meters - 2.meters).to eq(1.meter)
    end
  end
end
