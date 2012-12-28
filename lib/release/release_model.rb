require 'yaml'
require './lib/release/release_excel'
require './lib/release/release_io'

class ReleaseModel
  attr_accessor  :job_no, :release_label, :unit_type_array, :unitlist, :file, :piece_list_file, :release_filename
  attr_accessor  :filename, :directory, :eng_ero_release_directory, :program_directory, :release_directory
  attr_reader    :type_cats

  include ReleaseExcel
  include ReleaseIO

  def initialize(program_directory)
    #@state = state
    @program_directory = program_directory

    load "#{@program_directory}/lib/release/model/type_categories.rb"
    @type_cats = Type_Categories.new()

    load "#{@program_directory}/lib/release/model/unit.rb"
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