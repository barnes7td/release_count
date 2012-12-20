require 'yaml'

class CurrentRelease

  attr_accessor :data, :yml_file

  def initialize(rel)
    @yml_file = "#{rel.program_directory}/data/data.yml"
    @data = []
  end

  def save
    File.open(@yml_file, "w") { |f| YAML.dump(@data, f) }
  end

  def load_data
    File.open(@yml_file, "r") { |f| @data = YAML.load(f) }
  end

end