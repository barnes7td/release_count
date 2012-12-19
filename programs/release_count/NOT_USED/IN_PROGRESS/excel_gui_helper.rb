require 'release_class'
require 'win32ole'

e = WIN32OLE.connect('Excel.Application')
# Create Class for Excel Constants and Load
class ExcelConst
end
WIN32OLE.const_load(e, ExcelConst)


def create_header(ws, jobno, ero)
  title = ws.range('A1')
  jbn_lbl = ws.range('A2')
  jbn_cell = ws.range('B2')
  ero_lbl = ws.range('A3')
  ero_cell = ws.range('B3')

  title.value = 'RELEASE TALLY SHEET'
  title.font.size = 12
  title.font.bold = true

  jbn_lbl.value = 'JOB #:'
  jbn_lbl.HorizontalAlignment = ExcelConst::XlRight
  jbn_cell.value = jobno
  jbn_cell.Style = nil
  jbn_cell.HorizontalAlignment = ExcelConst::XlLeft

  ero_lbl.value = 'ERO:'
  ero_lbl.HorizontalAlignment = ExcelConst::XlRight
  ero_cell.value = ero
  ero_cell.Style = nil
  ero_cell.HorizontalAlignment = ExcelConst::XlLeft
end

def set_cell_sizes(ws, range)
  ws.columns('A').ColumnWidth = 7.86
  ws.columns('B').ColumnWidth = 7.86
  ws.columns(range).ColumnWidth = 3.14
end

def get_count_array(rel)
  array = []
  rel.unitlist.each_key {|k|
    array.push(k)
  }
  return array
end

def display_units(ws, units)
  cell = ws.range('B7')
  units.each {|u|
    cell.value = u
    cell = cell.offset(1, 0)
  }
end

def reset_sheet(ws)
  # figure out how to select all
  all = ws.selectall
  all.font.size = 11
end

class Xlgui
  
  def initialize
    @header =
    @
  end
  
end
