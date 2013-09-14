require 'spec_helper'

module Alchemist
  describe PrefixParser do
    it "can parse a prefix" do
      parsed = PrefixParser.new.parse(:kilometer)
      expect(parsed).to eq([1000.0, :meter])
    end
  end
end
