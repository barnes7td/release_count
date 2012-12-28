require 'factory_girl'
require './lib/release/report/counter'

describe Counter do
  
  before do
    @unitlist = {}
    FactoryGirl.define do
      factory :unit do
        name "P-1"
        type :post
        children {}
        ship_loos {}
      end
    end
  end

  it "should know the program_directory" do
    @ac.program_directory = File.expand_path("..",Dir.pwd)
  end

  # it "should have method :run" do
  #   @ac.should respond_to :run
  # end

end