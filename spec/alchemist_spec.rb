require 'spec_helper'

describe Alchemist do

  it "sets up Numeric" do
    category_module = build_category_module
    fake_numeric = build_fake_numeric
    Alchemist.setup('distance')
    expect(Alchemist::ModuleBuilder).to have_received(:new).with('distance')
    expect(fake_numeric).to have_received(:include).with(category_module)
  end

  it "creates a measurement" do
    unit = Alchemist.measure(1, :meter)
    expect(unit).to eq(1.meter)
  end

  def build_category_module
    double.tap do |category_module|
      module_builder = double()
      allow(module_builder).to receive(:build) { category_module }
      Alchemist::ModuleBuilder.stub(:new).and_return(module_builder)
    end
  end

  def build_fake_numeric
    double.tap do |fake_module|
      allow(fake_module).to receive(:include)
      stub_const("Numeric", fake_module)
    end
  end
end
