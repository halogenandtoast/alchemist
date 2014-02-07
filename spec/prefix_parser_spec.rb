require 'spec_helper'

module Alchemist
  describe PrefixParser do
    it "can parse a prefix" do
      parsed = PrefixParser.new(:kilometer)
      expect(parsed.exponent).to eq(1000.0)
      expect(parsed.unit_name).to eq(:meter)
    end

    it "can parse binary prefixes if si is off" do
      parsed = PrefixParser.new(:gigabyte)
      expect(parsed.exponent).to eq(1024 ** 3)
    end

    it "can parse si prefixes if si is on" do
      Alchemist.config.use_si = true
      parsed = PrefixParser.new(:gigabyte)
      expect(parsed.exponent).to eq(1000 ** 3)
    end
  end
end
