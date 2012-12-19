require 'win32ole'

class Xl_Writer
  
  def initialize(ws)
    @ws = ws
    @col_cell = @ws.range("A6")
  end

  def write_lines_across(info, start_cell)
    @no_col = info[0].length
    @offset = -1 * @no_col
    info = info
    cell = @ws.range(start_cell)
    
    info.each {|a|
      i = 0
      a.each {|v|
        cell.value = v.to_s
        i += 1
        cell = cell.offset(0, 1)
      }
      cell = cell.offset(1, @offset)
    }
    cell.value = "END"
  end

  def write_lines_down(info, start_cell)
    @no_col = info[0].length
    @offset = -1 * @no_col
    info = info
    cell = @ws.range(start_cell)

    info.each {|a|
      i = 0
      a.each {|v|
        cell.value = v.to_s
        i += 1
        cell = cell.offset(1, 0)
      }
      cell = cell.offset(9, 0)
    }
  end

end
