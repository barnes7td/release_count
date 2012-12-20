class ReleaseInfo

  def initialize(job_no, release_label)
    @job_no = job_no
    @release_label = release_label
  end

  def directories
    @data_directory     = "#{ENV["HOME"]}/Dropbox/Tuttle/release_count"
    @job_directory      = "#{@data_directory}/#{@job_no}"   
    @release_directory  = "#{@job_directory}/#{@job_no}_#{@release_label}_COUNT"
    @release_filename   = "#{@release_directory}/#{@job_no}-#{@release_label}.yml"

    load "#{@program_directory}/lib/release/io/job_folder_class.rb"
    jff = JobFolderFind.new @job_no

    @eng_job_directory = jff.directory
    @eng_ero_release_directory = "#{@eng_job_directory}/Release"
    @eng_ero_name = "#{@job_no} ERO #{@release_label}.xlsx"
    @eng_ero_file = "#{@eng_ero_release_directory}/#{@eng_ero_name}"

    @piece_list_name = "#{@job_no} #{@release_label} Piece List.xlsx"
    @piece_list_file = "#{@release_directory}/#{@piece_list_name}"
  end

  # def read_last_release
  #   load "#{@program_directory}/lib/release/io/current_release.rb"
  #   @current_release = CurrentRelease.new self

  #   @current_release.load_data
  #   @data             = @current_release.data 
  #   @job_no           = @data[0]
  #   @release_label    = @data[1]
  #   @release_filename = @current_release.yml_file
  #   setup
  # end

  # def set_release_info(arr)
  #   @job_no = arr[0]
  #   @release_label = arr[1]
  # end

  # ####

  # def setup   
  #   create_directory @job_directory
  #   create_directory @release_directory

  #   @current_release.save @job_no, @release_label

  #   set_job_folder_directories
  # end

  # def create_directory(dir)
  #   Dir.mkdir(dir) unless File.exists?(dir)
  # end

end