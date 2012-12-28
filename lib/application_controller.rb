require './lib/io/release_state'
require './lib/release/release_model'

class ApplicationController

  attr_accessor :program_directory, :release_state, :release_model

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

      @release_model = ReleaseModel.new @release_state
      @release_model.update_count
    end 
  end

  def previous_state
    @release_state.previous_state
  end

  def get_report(report)
    dir = "#{@release_state.info.app_release_directory}/#{get_report_filename(report)}"
    puts dir
    dir
  end

  def get_report_filename(report)
    case report
    when :sheet   then "Count_Sheets.txt"
    when :detail  then "Detail Breakdown.txt"
    when :post    then "Post Breakdown.txt"
    when :release then "Release_List.txt"
    when :ship    then "Ship_Loose_List.txt"
    when :tmr     then "TMR.txt"
    end
  end

end