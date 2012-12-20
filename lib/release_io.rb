module ReleaseIO

  def get_last_release
    load "#{@program_directory}/lib/release/io/current_release.rb"
    @current_release  = CurrentRelease.new(self)
    @current_release.load_data
    @data             = @current_release.data 
    @job_no           = @data[0]
    @release_label    = @data[1]
    setup
  end

  def setup
    set_job_folder_directories

    #Create FilE
    @job_directory      = "#{@data_directory}/#{@job_no}/"   
    @release_directory  = "#{@job_directory}/#{@job_no}_#{@release_label}_COUNT/"    
    @release_filename   = "#{@job_no}-#{@release_label}.yml"

    create_directory @job_directory
    create_directory @release_directory
  end

  def create_directory(dir)
    Dir.mkdir(dir) unless File.exists?(dir)
  end

  def set_job_folder_directories
    load "#{@program_directory}/lib/release/io/job_folder_class.rb"
    jff = JobFolderFind.new @job_no

    @eng_job_directory = jff.directory
    @eng_ero_release_directory = "#{@eng_job_directory}/Release/"
    @eng_ero_name = "#{@job_no} ERO #{@release_label}.xlsx"
    @eng_ero_file = "#{@eng_ero_release_directory}/#{@eng_ero_name}"

    @piece_list_name = "#{@job_no} #{@release_label} Piece List.xlsx"
    @piece_list_file = "#{@release_directory}/#{@piece_list_name}"
  end

  ####

  def save_release
    File.open(@filename, "w") do |f|
       YAML.dump(self, f)
    end
  end
  
  # def load_release(job_no, release_label)
  #   @job_no           = job_no
  #   @release_label    = release_label
  #   release = Release.new
  #   release.setup

  #   release = YAML.load File.read @current_release.yml_file
  # end


end