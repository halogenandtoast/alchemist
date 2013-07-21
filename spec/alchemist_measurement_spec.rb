require 'spec_helper'

describe "Alchemist measurement" do
  it "creates a measurement" do
    unit = Alchemist.measurement(1, :meter)
    expect(unit).to eq(1.meter)
  end
end
