require 'win32ole'

class Xl_Writer1
  
  def initialize(ws)
    @ws = ws
    @st_cell = @ws.range("A2")
  end

  def write_type(rel)
    cell = @st_cell
    test = nil
    until test == "END"
      name = cell.value
      type = rel.unitlist[name].type
      cell = cell.offset(0,2)
      cell.value = type.to_s unless name == nil
      cell = cell.offset(1, -2)
      test = cell.value
    end
  end

end
