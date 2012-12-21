# require 'pathname'
require './lib/application_controller'

describe ApplicationController do
  
  before do
    @ac = ApplicationController.new File.expand_path("..",Dir.pwd)
  end

  it "should know the program_directory" do
    @ac.program_directory = File.expand_path("..",Dir.pwd)
  end

  # it "should have method :run" do
  #   @ac.should respond_to :run
  # end

end