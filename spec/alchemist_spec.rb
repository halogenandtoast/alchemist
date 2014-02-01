require 'spec_helper'

describe Alchemist do
  it "loads a single category into the library" do
    library_double = stub_library

    Alchemist.setup('distance')

    expect(library_double).to have_received(:load_category).with('distance')
  end

  it "loads all categories into the library" do
    library_double = stub_library

    Alchemist.setup

    expect(library_double).to have_received(:load_all_categories)
  end

  it "creates a measurement" do
    unit = Alchemist.measure(1, :meter)

    expect(unit).to eq(1.meter)
  end

  it "delegates register to the Library" do
    stub_library

    Alchemist.register(:foo, :bar, :baz)

    expect(Alchemist.library).to have_received(:register).with(:foo, :bar, :baz)
  end

  it "builds a library" do
    library_double = stub_library

    expect(Alchemist.library).to eq library_double
  end

  it "builds its configuration" do
    configuration_double = stub_configuration

    expect(Alchemist.config).to eq configuration_double
  end

  it "will reset! the library" do
    stub_library
    2.times { Alchemist.library }
    Alchemist.reset!
    Alchemist.library
    expect(Alchemist::Library).to have_received(:new).twice
  end

  it "will reset! the configuration" do
    stub_configuration
    2.times { Alchemist.config }
    Alchemist.reset!
    Alchemist.config
    expect(Alchemist::Configuration).to have_received(:new).twice
  end

  def stub_library
    double(Alchemist::Library, library_methods).tap do |library_double|
      allow(Alchemist::Library).to receive(:new).and_return(library_double)
    end
  end

  def library_methods
    {
      register: true,
      load_category: true,
      load_all_categories: true
    }
  end

  def stub_configuration
    double(Alchemist::Configuration).tap do |configuration_double|
      allow(Alchemist::Configuration).to receive(:new).and_return(configuration_double)
    end
  end
end
