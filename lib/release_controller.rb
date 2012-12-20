require 'yaml'
require './lib/release'
require './lib/release_info'


class ReleaseController

  attr_accessor :rel_info, :yml_file, :rel_dir, :rel, :rel_info

  def initialize(program_directory)
    @yml_file = "#{program_directory}/data/data.yml"
  end

  def exists?
    yaml_file_exists? && is_valid?
  end

  def yaml_file_exists?
    File.exists? @yml_file 
  end

  def is_valid?
    load_data
    @rel_info[0].length > 4
  end

  def save
    File.open(@yml_file, "w") { |f| YAML.dump(@rel_info, f) }
  end

  def load_data
    File.open(@yml_file, "r") { |f| @rel_info = YAML.load(f) }
  end

  ##--In Progress
  def load_release
    create_release
    @rel = load_data
    get_directories
    @rel
  end

  def get_directories
    @rel_dir = ReleaseDirectories.new @rel_info
  end

  def create_release
    @rel = Release.new @rel_info
  end


end