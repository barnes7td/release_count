require 'release_class'
require 'win32ole'

e = WIN32OLE.connect('Excel.Application')
# Create Class for Excel Constants and Load
class ExcelConst
end
WIN32OLE.const_load(e, ExcelConst)

 def select_workbook(excel)
  index = 1
  wblist = []

  excel.workbooks.each{|wb|
    wblist[index] = wb.name
    puts index.to_s + ". " + wb.name
    index = index.to_i + 1
  }
  puts
  puts "Select Workbook by Number"
  choice= gets.chomp.to_i
  wb_name = wblist[choice]
  wb = excel.Workbooks(wb_name)
  wb.Activate
  return wb
end

def select_worksheet(workbook)
  index = 1
  wslist = []

  workbook.worksheets.each {|ws|
    wslist[index] = ws.name
    puts index.to_s + ". " + ws.name
    index = index.to_i + 1
  }
  puts
  puts "Select Workbook by Number"
  choice= gets.chomp.to_i
  ws_name = wslist[choice]
  ws =  workbook.Worksheets(ws_name)
  ws.Activate
  return ws
  end


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

def read_list_count(ws)
  #read_header(ws)
  d = read_lines(ws)
  return d
end

def read_header(ws)
  info = []
  info << ws.range("B1") #job number
  info << ws.range("B2") #rel letter
  return info
end

def read_lines(ws)
  sheet_data = []
  line_data = []
  cell = ws.range("A5")
  17.times{
    7.times{
    line_data << cell.value
    cell = cell.offset(0,1)
    }
    sheet_data << line_data
    cell = cell.offset(1,-7)
    line_data = []
  }
  #print_lines(sheet_data)
  return sheet_data
end

def print_lines(array)
  array.each {|a|
    p a
  }
end