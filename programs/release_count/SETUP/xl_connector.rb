require 'win32ole'

class Xl_Connector

  attr_reader  :xl
  attr_reader  :wb
  attr_reader  :ws_sheets
  attr_reader  :ws_details
  attr_reader  :ws_test
  attr_reader  :ws
  attr_accessor  :reg_ex_wb
  attr_accessor  :reg_ex_ws

  def initialize
    @xl = WIN32OLE.connect('Excel.Application')
    @wb = nil
    @ws = nil
  end

  def get_sheet(sheet_name)
    ws_list = []
    @wb.Worksheets.each do |ws|
      ws_list << ws.name
    end
    @ws_sheets = wb.Worksheets(sheet_name) if ws_list.include? sheet_name
  end

  def set_book(wb_name)
      @wb = @xl.Workbooks(wb_name)
      @wb.Activate
      return @wb
  end

  def open_workbook(filename)
    @xl.workbooks.open filename
  end

  def get_wb_list(wb, list, index)
    list[index] = wb.name
    puts index.to_s + ". " + wb.name
    index = index.to_i + 1
    return [list, index]
  end

  def select_workbook(select_text = "Please Select File", reg_ex_wb = nil)
    index = 1 
    wb_list = []
    #
    puts
    puts "Workbook List:"
    @xl.workbooks.each{|wb|
      if reg_ex_wb != nil
        #puts "yes"
        test = reg_ex_wb =~ wb.name.downcase
        unless test == nil
          wb_list[index] = wb.name
          puts index.to_s + ". " + wb.name
          index = index.to_i + 1
        end
      else
        wb_list[index] = wb.name
        puts index.to_s + ". " + wb.name
        index = index.to_i + 1
      end
    }
    if wb_list.length == 2
      choice = 1
    else
      puts
      puts select_text
      puts "Select Workbook by Number"
      choice= gets.chomp.to_i
    end
    wb_name = wb_list[choice]
    puts
    puts "#{wb_name} was chosen"
    puts
    @wb = @xl.Workbooks(wb_name)
    @wb.Activate
    return @wb
  end

  def select_worksheet(select_text = "Please Select File", reg_ex_wb = nil)
    index = 1
    wslist = []
    #
    @wb.worksheets.each {|ws|
      wslist[index] = ws.name
      puts index.to_s + ". " + ws.name
      index = index.to_i + 1
    }
    puts
    puts select_worksheet
    puts "Select Workbook by Number"
    choice= gets.chomp.to_i
    ws_name = wslist[choice]
    @ws = @wb.Worksheets(ws_name)
    @ws.Activate
    return @ws
  end
  
end
