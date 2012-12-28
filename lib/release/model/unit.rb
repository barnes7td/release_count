class Unit

  attr_accessor  :name, :type

  def initialize(name, type)
    @name = name
    @type = type
    @children = []
  end

  def add_child(name, qty, ship_loose=0)
    @children << Child.new(name, qty, ship_loose=0)
  end

  def find_child(name)
    @children.select{|c| c.name == name}
  end

  def delete_child(child_name)
    @children.delete(child_name)
  end

  def get_all_children
    @children.selet{|child| child.name}
  end

end

class Child
  attr_accessor :name

  def initialize(name, qty, ship_loose)
    @name = name
    @qty = qty
    @ship_loose = ship_loose
  end

end
