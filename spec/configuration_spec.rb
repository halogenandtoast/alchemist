require 'spec_helper'

module Alchemist
  describe Configuration do
    it "defaults use_si to false" do
      config = Configuration.new
      expect(config.use_si?).to be false
    end

    it "allows use_si to be changed" do
      config = Configuration.new
      config.use_si = true
      expect(config.use_si?).to be true
    end
  end
end
