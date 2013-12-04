require 'spec_helper'

module Alchemist
  describe PrefixParser do
    it "can parse a prefix" do
      parsed = PrefixParser.new.parse(:kilometer)
      expect(parsed).to eq([1000.0, :meter])
    end

    it "can parse binary prefixes if si is off" do
      parsed = PrefixParser.new.parse(:gigabyte)
      expect(parsed).to eq([1024 ** 3, :byte])
    end

    it "can parse si prefixes if si is on" do
      Alchemist.config.use_si = true
      parsed = PrefixParser.new.parse(:gigabyte)
      expect(parsed).to eq([1000 ** 3, :byte])
    end
  end
end
