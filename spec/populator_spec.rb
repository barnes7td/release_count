require 'spec_helper'
require_relative '../programs/release_count/SETUP/populator.rb'

describe Populator, "#populate_model" do
  it "creates an instance" do
    data = [[], []]
    pop = Populator.new(data, SHOES)
    pop.class == Populator
  end
end