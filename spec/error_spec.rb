require "spec_helper"

describe Alchemist, "errors" do
  it "raises IncompatibleTypeError when invalid types are used" do
    expect { 1.second + 1.meter }.to raise_error(Alchemist::IncompatibleTypeError)
  end

  it "throws GeospatialArgumentError when invalid type is used" do
    expect { 1.second.geospatial }.to raise_error(Alchemist::GeospatialArgumentError)
  end
end
