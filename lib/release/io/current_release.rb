require 'yaml'

class CurrentRelease

  attr_accessor :data, :yml_file

  def initialize(rel)
    @yml_file = "#{rel.program_directory}/data/data.yml"
  end

  def create_data_file
    File.open(@yml_file, "w") { |f| f.puts " " }
  end

  def exists?
    File.exists? @yml_file
  end

  def save(job_no, release_label)
    @data = [job_no, release_label]
    create_data_file unless exists?
    File.open(@yml_file, "w") { |f| YAML.dump(@data, f) }
  end

  def load_data
    File.open(@yml_file, "r") { |f| @data = YAML.load(f) }
  end

end