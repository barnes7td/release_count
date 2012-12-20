require 'win32ole'

class Xl_Reader

  attr_reader  :header
  attr_reader  :lines
  
  def initialize(ws)
    #@xl = xl
    #@wb = wb
    @ws = ws
    @start_cell = @ws.range("A7")
    @col_cell = @ws.range("A6")
    @no_col = 20

    @header = read_header
    @lines = read_lines
  end
  
  def get_info
    return [@header, @lines]
  end

  def read_header
    info = []

    ## TODO FIX FOR MECHANICAL (.to_i) ##
    jn = @ws.range("B3").value #job number
    if jn.class == Float
      jn = jn.to_i.to_s
    else jn = jn.to_s
    end
    info << jn #job number
    info << @ws.range("B4").value.to_s #release letter
    return info
  end

  def determine_columns
    cell = @col_cell
    test = cell.value
    count = 0
    until test == nil
      cell = cell.offset(0, 1)
      test = cell.value
      count += 1
    end
    return count
  end

  def read_lines
    off = -1 * @no_col
    sheet_data = []
    cell = @start_cell
    test = cell.value
    until test == "END"
      array = get_line_info(@no_col, cell)
      cell = array[0]
      sheet_data << array[1]
      cell = cell.offset(1, off)
      test = cell.value
    end
    return sheet_data
  end

  def get_line_info(number, cell)
    line_data = []
    number.times{
      line_data << cell.value
      cell = cell.offset(0,1)
      }
    return [cell, line_data]
  end


  def print_lines
    @lines.each {|a|
      p a
    }
  end

end
