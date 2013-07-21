require 'spec_helper'

describe "Alchemist compound units" do
  it "can handle compound units" do
    expect(30.miles).to eq(10.miles.per.second * 3.seconds)
  end

  it "can handle elimination of a unit" do
    expect(4.m.per.m).to eq(4)
  end
end
