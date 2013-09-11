require 'spec_helper'

module Alchemist
  describe Library do
    it "returns a list of the binary prefixes" do
      expect(Library.instance.binary_prefixes[:kilo]).to eq(1024.0)
    end
  end
end
