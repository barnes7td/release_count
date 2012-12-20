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