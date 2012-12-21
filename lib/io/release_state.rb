require './lib/io/release_saved_state'
require './lib/io/release_info'

class ReleaseState

  attr_accessor :job_no, :release_label

  def initialize(program_directory)
    @job_no        = "Not Defined"
    @release_label = "Not Defined"

    @saved_state   = ReleaseSavedState.new program_directory
    @info          = ReleaseInfo.new program_directory
  end

  def previous_state
    @saved_state.load
  end

  def update_info
    @info.update @saved_state.release_info[0], @saved_state.release_info[1]
  end

end