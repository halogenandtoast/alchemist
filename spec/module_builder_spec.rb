require 'spec_helper'

module Alchemist
  describe ModuleBuilder do
    it "allows methods to be added to the build module" do
      allow(Alchemist).to receive(:library).and_return(library_double)
      builder = ModuleBuilder.new(:test)
      test_module = builder.build
      test_module.define_unit_method([:wombat])
      expect(test_module.instance_methods).to include(:wombat)
    end

    def library_double
      double(Alchemist::Library, unit_names: [], si_units: [])
    end
  end
end
