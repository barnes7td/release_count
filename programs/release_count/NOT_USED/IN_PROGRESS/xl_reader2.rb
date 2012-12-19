require 'win32ole'

class Xl_Reader2

  attr_reader  :header
  attr_reader  :lines
  
  def initialize(ws)
    #@xl = xl
    #@wb = wb
    @ws = ws
    @start_cell = @ws.range("A7")
    @col_cell = @ws.range("A6")
    @no_col = determine_columns

    @header = read_header
    @lines = read_lines
  end
  
  def get_info
    return [@header, @lines]
  end

  def read_header
    info = []
    info << @ws.range("B3").value #job number
    info << @ws.range("B4").value #release letter
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

  def read_lines2
    off = -1 * @no_col
    level = 1
    sheet_data = []
    cell = @start_cell
    test = cell.value
    until test == "END"
      array = get_line_info2(@no_col, cell)
    end
  end

  def get_line_info2(number, cell, level)
    line_data = []
    #get first cell in line value
    cell = cell.offset(0, level)
    if cell.value == "["
    then level += 1
      line_data << "DOWN"
    else if cell.address[0] == "B"
         then line_data << "SHEET"
        cell = cell.offset(0, -1)
    end
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
