require 'spec_helper'

module Alchemist
  describe ConversionTable do
    after(:each) do
      load_file default_file
    end

    it "should use the new file" do
      load_file good_file
      expect(conversion_table[:volume]).to eq({ litre: 1.0, swallow: 0.006, pint: 0.5506105 })
    end

    it "should use the defaults when it fails to load" do
      load_file bad_file
      expect(5280.feet).to eq(1.mile.to.feet)
    end

    def conversion_table
      Alchemist.library.conversion_table
    end

    def load_file file
      Alchemist.library.load_conversion_table file
    end

    def good_file
      File.join(File.dirname(__FILE__), "fixtures", "good_test.yml")
    end

    def bad_file
      File.join(File.dirname(__FILE__), "fixtures", "bad_test.yml")
    end

    def default_file
      Configuration::DEFAULT_UNITS_FILE
    end
  end
end
