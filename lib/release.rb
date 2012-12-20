require 'yaml'
require './lib/release_excel'
require './lib/release_io'

class Release
  attr_accessor  :job_no, :release_label, :unit_type_array, :unitlist, :file, :piece_list_file
  attr_accessor  :filename, :directory, :eng_ero_release_directory, :program_directory
  attr_reader    :type_cats

  include ReleaseExcel
  include ReleaseIO

  def initialize(shoes, program_directory)
    @shoes = shoes
    @program_directory = program_directory
    @data_directory    = "#{ENV["HOME"]}/Dropbox/Tuttle/release_count"

    load "#{@program_directory}/lib/release/type_categories.rb"
    @type_cats = Type_Categories.new()

    load "#{@program_directory}/lib/release/unit.rb"
    @unitlist = Hash.new #|name, id|
    @unitlist['EXTRA'] = Unit.new('EXTRA', :sheet)
  end
 
  def unit_exist?(name)
    @unitlist.has_key?(name)
  end

  def add_unit(name, type)
    if @unitlist.has_key?(name)
      id = @unitlist[name]
    else 
      id = Unit.new(name, type)
      @unitlist[name] = id
    end
    return id
  end
  
  def return_list(type)
    type_array = []
    @unitlist.each_key do |k|
      if v.type == type
        type_array.push(k)
      end
    end
    return type_array
  end

  def list_units
    type_array = []
    @unitlist.each_key {|k|
         type_array.push(k)
    }
    return type_array
  end

 end