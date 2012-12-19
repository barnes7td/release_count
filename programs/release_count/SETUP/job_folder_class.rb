class JobFolderFindClass
  attr_reader :directory, :directories, :job_type

  def initialize(job_no)
    @MAIN_DIRECTORY = "S:/Engineering/engstore/"
    @job_no = job_no
    determine_job_type
    @directory = find_folders
    #find_release_directories
  end

  def validate_job_no(job_no)
    #could make better
    if job_no.length == 4 | 5 | 9
      return true
    else return false
    end
  end

  def find_release_directories #Returns an array of string directories
    dirs = [directory]
    Dir.foreach(directory) do |entry|
      if /release/ =~ entry.downcase
        @directories << "#{directory}/#{entry}"
      end
    end
  end

  def find_ero_files
    find_release_directories
    files = []
    @directories.each do |dir|
      Dir.foreach(dir) do |entry|
        if /ero/ =~ entry.downcase
          files << "#{directory}/#{entry}"
        end
      end
    end
  end

  private

  def determine_job_type
    @job_type = case @job_no.length
    when 4 then :mechanical
    when 5 then :rocky
    when 9 then :welded
    else :undefined
    end
  end

  def find_folders 
    case @job_type
    when :mechanical
      first_digit = @job_no[0]
      second_digit = @job_no[1]
      dir = "#{@MAIN_DIRECTORY + first_digit}XXX/#{first_digit + second_digit}00-#{first_digit + second_digit}99/#{@job_no}"
    when :rocky
      second_digit = @job_no[1]
      third_digit = @job_no[2]
      dir = "#{@MAIN_DIRECTORY}RMR JOBS/R#{second_digit + third_digit}00-R#{second_digit + third_digit}99/#{@job_no}" if @job_no[1..4].to_i < 2000 
      dir = "#{@MAIN_DIRECTORY}RMR JOBS/R#{second_digit + third_digit}00-R#{second_digit + (third_digit.to_i + 1).to_s}00/#{@job_no}" if @job_no[1..4].to_i >= 2000 && @job_no[1..4].to_i <= 2100
      dir = "#{@MAIN_DIRECTORY}RMR JOBS/R#{second_digit + third_digit}01-R#{second_digit + (third_digit.to_i + 1).to_s}99/#{@job_no}" if @job_no[1..4].to_i < 2100
    when :welded
      year_code = @job_no.match(/\d\d\d/).to_s
      year = year_code.insert(1, "0")
      dir = "#{@MAIN_DIRECTORY + year}/#{@job_no}"
    end
    return dir
  end

end
