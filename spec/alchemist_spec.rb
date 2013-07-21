require 'spec_helper'

describe Alchemist do
  it "can compare units" do
    expect(1.m).to eq(1.meter)
  end

  it "can convert units" do
    expect(5.grams).to eq(0.005.kilograms)
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
    expect(1.quut).to eq(3.qaat)
  end

  it "can register units with plural names" do
    Alchemist.register(:distance, [:beard_second, :beard_seconds], 5.angstroms)
    expect(2.beard_seconds).to eq(10.angstroms)
  end

  it "can register units with formulas" do
    Alchemist.register(:temperature, :yeti, [Proc.new{|t| t + 1}, Proc.new{|t| t - 1}])
    expect(0.yeti).to eq(1.kelvin)
  end

  it "can convert to other datatypes" do
    expect(10.meters.to_i).to eq(10)
    expect(10.meters.to_f).to eq(10.0)
    expect(10.meters.to_s).to eq("10.0")
  end
end
