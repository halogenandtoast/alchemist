require 'spec_helper'

module Alchemist
  describe ConversionTable do

    it "loads a properly formed file" do
      conversion_table = ConversionTable.new
      expect(conversion_table.load_all(good_file)).not_to be_nil
    end

    it "fails to load a improperly formed file" do
      conversion_table = ConversionTable.new
      expect(conversion_table.load_all(bad_file)).to be_nil
    end


    def good_file
      File.join(File.dirname(__FILE__), "fixtures", "good_test.yml")
    end

    def bad_file
      File.join(File.dirname(__FILE__), "fixtures", "bad_test.yml")
    end
  end
end
