require 'yaml'

load "#{$DIR}/programs/release_count/MODEL/type_categories.rb"

class Release
   attr_accessor  :jobno
   attr_accessor  :releaselabel
   attr_accessor  :unit_type_array
   attr_accessor  :unitlist
   attr_accessor  :file
   attr_accessor  :filename
   attr_accessor  :directory
   attr_reader    :type_cats

  def initialize(shoes)
    @shoes = shoes
    @unitlist = Hash.new #|name, id|
    extra = Unit.new('EXTRA', :sheet)
    @unitlist['EXTRA'] = extra
    @type_cats = Type_Categories.new()
 end
 
 def setup(jobno, releaselabel)
   @jobno = jobno
   @releaselabel = releaselabel

   #Create FilE
   puts @program_dir
   @job_directory = "#{SHOES.job_base_dir}/#{@jobno}/"
   set_dir(@job_directory)
   @directory = "#{@job_directory}/#{@jobno}_#{@releaselabel}_COUNT/"
   set_dir(@directory)
   Dir.chdir(@directory) unless Dir.pwd == @directory
   @filename = "#{@jobno}-#{@releaselabel}.yml"
 end
 
	def set_dir(dir)
    unless File.exists?(dir)
      Dir.mkdir(dir)
			#puts "Directory (#{dir}) is set"
    end
    #puts "Directory (#{dir}) already exists"
  end

  def unit_exist?(name)
    if @unitlist.has_key?(name)
    then return true
    else return false
    end
  end

  def add_unit(name, type)
    if @unitlist.has_key?(name)
    then id = @unitlist[name]
    else id = Unit.new(name, type)
      @unitlist[name] = id
    end
    return id
  end

  def delete_unit(name)
    @unitlist.delete(name) if @unitlist.has_key?(name)
  end

  def create_file
    @file = File.new(@filename, "w")
  end

  def save_release
		File.open(@filename, "w"){|f|
			 YAML.dump(self, f)
			}
	end
	
	def load_release(jobno, releaselabel)
		@filename = "#{$DIR}/data/Release_Count/#{@jobno}/#{@jobno}_#{@releaselabel}_COUNT/#{@jobno}-#{@releaselabel}.yml"
		YAML.load File.read @filename
		setup(jobno, releaselabel.upcase)
		puts
		puts "Release has been loaded"
		puts
	end

  def release_name
    return "#{jobno} #{releaselabel}"
  end
  
  def return_list(type)
    type_array = []
    @unitlist.each_pair {|k, v|
         if v.type == type
         type_array.push(k)
         end
    }
    return type_array
  end

  def list_units
    type_array = []
    @unitlist.each_key {|k|
         type_array.push(k)
    }
    return type_array
  end

 end #Release class



## UNIT CLASS ##

class Unit

  attr_accessor  :name
  attr_accessor  :type
  attr_accessor  :children
  attr_accessor  :ship_loose

  def initialize(name, type)
    @name = name
    @type = type
    @children = Hash.new #|name, qty|
    @ship_loose = Hash.new #|name, qty|
  end

  def add_child(rel, child_name, type, qty, sl_qty)
    @children[child_name] = qty unless @children.has_key?(child_name)
    if sl_qty != nil
      @ship_loose[child_name] = sl_qty unless @ship_loose.has_key?(sl_qty)
    end
    if rel.unitlist.has_key?(child_name)
    then child_id = rel.unitlist[child_name]
    else child_id = Unit.new(child_name, type)
      rel.unitlist[child_name] = child_id
    end
    return child_id
  end

  def edit_child(child_name, new_qty)
    if @children.has_key?(child_name)
    then @children[child_name] = new_qty
    else puts "Dependent does not exist"
    end
  end

  def delete_child(child_name)
    if @children.has_key?(child_name)
    then @children.delete(child_name)
    else puts "Dependent does not exist"
    end
  end

  def get_children_array
    type_array = []
    @children.each_key {|k|
         type_array.push(k)
    }
    return type_array
  end

  def list_children
    puts "#{self.name}'s dependents:"
    @children.each_pair {|n,q|
      puts "#{n} = #{q}"
    }
  end

  def list_comps(comp_array)#SHOULD BE childs AS ARGUMENT
    # BUILD A 2 DIMENSIONAL ARRAY
    posts = []
    rail = []
    comp_array.each {|c|
      case c.type
      when 'POSTS'
        posts.push c
      when 'RAIL'
        rail.push c
      end
    }
    puts
    puts 'POSTS'
    post.each {|p|
      puts p.name + '  '+ c.qty.to_s
      puts c.childs.each_key{|k|
      puts "  #{k.name} = #{childs[k].to_s}"
      }
    }
  end


end
