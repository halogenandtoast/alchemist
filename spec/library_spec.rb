require 'spec_helper'

module Alchemist
  describe Library do
    it "returns a list of the binary prefixes" do
      expect(library.binary_prefixes[:kilo]).to eq(1024.0)
    end

    it "can register units with formulas" do
      to = lambda { |t| t + 1 }
      from = lambda { |t| t - 1 }
      library.register(:yetis, :yeti, [to, from])
      expect(library.conversion_table[:yetis]).to eq({:yeti => [to, from]})
    end

    it "can register units with plural names" do
      library.register(:beards, [:beard_second, :beard_seconds], 1.0)
      expect(library.conversion_table[:beards]).to eq({:beard_second=>1.0, :beard_seconds=>1.0})
    end

    it "can register units" do
      library.register :quux, :qaat, 1.0
      library.register :quux, :quut, 3.0
      expect(library.conversion_table[:quux]).to eq({:qaat=>1.0, :quut=>3.0})
    end

    it "knows if it has a measurement" do
      expect(library.has_measurement?(:meter)).to be_true
    end

    it "knows if it doesn't have a measurement" do
      expect(library.has_measurement?(:wombat)).to be_false
    end

    def library
      Library.instance
    end
  end
end
