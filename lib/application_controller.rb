require './lib/io/release_state'

class ApplicationController

  attr_accessor :program_directory, :release_state

  def initialize(shoes, program_directory)
    @shoes = shoes
    @program_directory  = program_directory
    @release_state      = ReleaseState.new program_directory
    initialize_state
  end

  def initialize_state
    if previous_state
      @shoes.display_job_info previous_state[0], previous_state[1]
      @release_state.update_info
    end 
  end

  def previous_state
    @release_state.previous_state
  end

end