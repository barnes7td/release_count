require 'yaml'

class ReleaseSavedState

  attr_accessor :release_info, :yml_file

  def initialize(program_directory)
    @yml_file = "#{program_directory}/data/data.yml"
    @release_info = ["-", "-"]
    load
  end

  def save(job_no, release_label)
    @release_info = [job_no, release_label]
    save_to_file
  end

  def load
    if exists?
      load_from_file
      @release_info
    else
      false
    end
  end

  def exists?
    yaml_file_exists? && is_valid?
  end

  private

  def yaml_file_exists?
    File.exists? @yml_file 
  end

  def is_valid?
    load_from_file
    @release_info[0].length > 4
  end

  def save_to_file
    File.open(@yml_file, "w") { |f| YAML.dump(@release_info, f) }
  end

  def load_from_file
    File.open(@yml_file, "r") { |f| @release_info = YAML.load(f) }
  end

end