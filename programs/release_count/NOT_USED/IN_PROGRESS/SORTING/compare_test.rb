
class Rail_Mark
  
  attr_accessor  :name
  attr_accessor  :sheet
  attr_accessor  :rel
  attr_accessor  :railno
  
  def initialize(name)
    @name = name
    seperate_name
  end
  
  def seperate_name
    /(\d+)(\D+)(\d+)/ =~ @name
      @sheet = $1.to_i
      @rel =  $2
      @railno =  $3.to_i
  end
    
  def <(rail_mark)
    if self.rel< rail_mark.rel
      return true
    else if self.sheet <rail_mark.sheet
           return true
           else if self.railno <rail_mark.railno
                  return true
                  else return false
                  end
           end
    end

  end

end

rail1 = Rail_Mark.new("48A7")
rail2 = Rail_Mark.new("48B7")
rail3 = Rail_Mark.new("47A7")

test = []

test.push rail1 < rail2
test.push rail2 < rail1
test.push rail1 < rail3
test.push rail2 < rail3
puts test