require 'spec_helper'

module Alchemist
  RSpec.describe "byte conversions" do
    it "uses JEDEC specification" do
      expect(1.kb.to.b.to_f).to eq(1024.0)
    end

    it "uses SI when configured to do so" do
      Alchemist.config.use_si = true
      expect(1.kb.to.b.to_f).to eq(1000.0)
    end
  end
end
