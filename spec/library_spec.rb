require 'spec_helper'

module Alchemist
  describe Library do
    it "returns a list of the binary prefixes" do
      library = Library.new
      expect(library.binary_prefixes[:kilo]).to eq(1024.0)
    end

    it "can register units with formulas" do
      stub_loading
      library = Library.new
      library.load_category :yetis
      to = lambda { |t| t + 1 }
      from = lambda { |t| t - 1 }
      library.register(:yetis, :yeti, [to, from])
      expect(library.conversion_table[:yetis]).to eq({:yeti => [to, from]})
    end

    it "can register units with plural names" do
      stub_loading
      library = Library.new
      library.load_category :beards
      library.register(:beards, [:beard_second, :beard_seconds], 1.0)
      expect(library.conversion_table[:beards]).to eq({:beard_second=>1.0, :beard_seconds=>1.0})
    end

    it "can register units" do
      stub_loading
      library = Library.new
      library.load_category :quux
      library.register :quux, :qaat, 1.0
      library.register :quux, :quut, 3.0
      expect(library.conversion_table[:quux]).to eq({:qaat=>1.0, :quut=>3.0})
    end

    it "knows if it has a measurement" do
      library = Library.new
      expect(library.has_measurement?(:meter)).to be true
    end

    it "knows if it doesn't have a measurement" do
      library = Library.new
      expect(library.has_measurement?(:wombat)).to be false
    end

    def stub_loading
      module_double = double(Module, define_unit_method: true)
      allow(ModuleBuilder).to receive(:new).and_return(module_double)
      allow(Numeric).to receive(:send).with(:include, module_double).and_return(true)
    end
  end
end
