require './release_class'

class Populator

  attr_accessor :rel

  def initialize(data)
    @sheet = nil
    @rail = nil
    @form_data = data
    @header = data[0]
    @lines = data[1]

    @rel = Release.new(@header[0], @header[1])
    populate_model(@lines)
  end
  
  def create_release
    @rel = Release.new(@header, @lines)
  end

  def populate_model(a_of_a)
    a_of_a.each {|a|
      set_sheet(a[0])
      set_rail(a[1], a[2])
      set_unit(a[3], a[4], a[5])
    }
    @rel.save_release
  end

  def set_sheet(name)
    @sheet = @rel.add_unit(name, :sheet)

  end

  def set_rail(name, qty)
    @rail = @sheet.add_child(@rel, name, qty, :rail)
  end

  def set_unit(type, name, qty)
    @unit = @rail.add_child(@rel, name, qty, type)
  end

end
