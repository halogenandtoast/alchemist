require 'spec_helper'

describe Alchemist do

  it "sets up Numeric" do
    fake_module = double()
    fake_module.should_receive(:include).with(Alchemist::Conversion)
    stub_const("Numeric", fake_module)
    Alchemist.setup
  end

  it "creates a measurement" do
    unit = Alchemist.measure(1, :meter)
    expect(unit).to eq(1.meter)
  end

  it "knows if it has a measurement" do
    expect(Alchemist.has_measurement?(:meter)).to be_true
  end

  it "knows if it doesn't have a measurement" do
    expect(Alchemist.has_measurement?(:wombat)).to be_false
  end

  it "can register units" do
    Alchemist.register :quux, :qaat, 1.0
    Alchemist.register :quux, :quut, 3.0
    expect(Alchemist.conversion_table[:quux]).to eq({:qaat=>1.0, :quut=>3.0})
  end

  it "can register units with plural names" do
    Alchemist.register(:beards, [:beard_second, :beard_seconds], 1.0)
    expect(Alchemist.conversion_table[:beards]).to eq({:beard_second=>1.0, :beard_seconds=>1.0})
  end

  it "can register units with formulas" do
    to = lambda { |t| t + 1 }
    from = lambda { |t| t - 1 }
    Alchemist.register(:yetis, :yeti, [to, from])
    expect(Alchemist.conversion_table[:yetis]).to eq({:yeti => [to, from]})
  end

  it "can parse a prefix" do
    parsed = Alchemist.parse_prefix(:kilometer)
    expect(parsed).to eq([1000.0, :meter])
  end
end
