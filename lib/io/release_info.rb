class ReleaseInfo
  attr_accessor :job_no, :release_label, :app_release_directory

  def initialize(program_directory)
    @program_directory = program_directory
  end

  def update(job_no, release_label)
    @job_no             = job_no
    @release_label      = release_label
    set_directories
  end

  private

  def set_directories
    @app_data_directory        = "#{ENV["HOME"]}/Dropbox/Tuttle/release_count"
    @app_job_directory         = "#{@app_data_directory}/#{@job_no}"   
    @app_release_directory     = "#{@app_job_directory}/#{@job_directory}/#{@job_no}_#{@release_label}_COUNT"
    @app_release_filename_full = "#{@app_release_directory}/#{@job_no}-#{@release_label}.yml"

    load "#{@program_directory}/lib/io/engineering_job_folder.rb"
    @eng_job_folder = EngineeringJobFolder.new @job_no

    @eng_job_directory         = @eng_job_folder.directory
    @eng_release_directory     = "#{@eng_job_directory}/Release"
    @eng_ero_filename          = "#{@job_no} ERO #{@release_label}.xlsx"
    @eng_ero_filename_full     = "#{@eng_release_directory}/#{@eng_ero_name}"

    @piece_list_filename       = "#{@job_no} #{@release_label} Piece List.xlsx"
    @piece_list_filename_full  = "#{@release_directory}/#{@piece_list_name}"
  end

end