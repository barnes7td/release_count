require 'win32ole'

class Xl_Connector

  attr_reader  :xl
  attr_reader  :wb
  attr_reader  :ws_sheets
  attr_reader  :ws_details
  attr_reader  :ws_test
  attr_reader  :ws

  def initialize
    @xl = WIN32OLE.connect('Excel.Application')
  end

  def get_sheets(wb)
    @ws_sheets = wb.Worksheets("SHEETS")
    @ws_details = wb.Worksheets("DETAILS")
  end

  def select_workbook(statement)
    index = 1
    wblist = []
    #
    @xl.workbooks.each{|wb|
      wblist[index] = wb.name
     puts index.to_s + ". " + wb.name
      index = index.to_i + 1
    }
    puts
    puts statement
    puts "Select Workbook by Number"
    choice= gets.chomp.to_i
    wb_name = wblist[choice]
    wb = @xl.Workbooks(wb_name)
    wb.Activate
    return wb
  end

  def select_worksheet(wb, statement)
    index = 1
    wslist = []
    #
    wb.worksheets.each {|ws|
      wslist[index] = ws.name
      puts index.to_s + ". " + ws.name
      index = index.to_i + 1
    }
    puts
    puts statement
    puts "Select Workbook by Number"
    choice= gets.chomp.to_i
    ws_name = wslist[choice]
    ws =  wb.Worksheets(ws_name)
    ws.Activate
    @ws = ws
    return @ws
  end
  
end
