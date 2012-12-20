class Populator

  attr_accessor :rel
  attr_reader :data

  def initialize(data, rel)
    @rel = rel
    load "#{@rel.program_directory}/programs/release_count/MODEL/release_class.rb"

    @sheet = nil
    @rail = nil
    @form_data = data
    @header = data[0]
    @lines = data[1]

    @rel.set_release_info(@header[0], @header[1])
		@rel.setup
    populate_model(@lines)
  end

  def populate_model(a_of_a)
    a_of_a.each {|a|
      if a[0] == "REL"
        add_to_rel(a)
      else add_to_unit(a)
      end
    }
    @rel.save_release
  end

  def add_to_rel(a)
    @rel.add_unit(a[1], a[2]) #ONLY FOR SHEETS NOW
  end

  def add_to_unit(a)
    if @rel.unitlist[a[0]] == nil 
    then p a
    else child = @rel.unitlist[a[0]].add_child(@rel, a[1], a[2], a[3], a[4])
    end
  end

end
