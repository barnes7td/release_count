
require 'xl_connector'
require 'xl_reader'
require 'xl_writer'
require 'formatter'
require 'sorter_bom'
require 'populator'
require 'reporter'
require 'counter'
require 'console_printer'
require 'main_1'


#require 'win32ole'
#require 'excel_helper'
#require 'decipher'

#xl = WIN32OLE.connect('Excel.Application')
#xl['Visible'] = true

#CONNECT TO EXCEL
xlc = Xl_Connector.new()
xl = xlc.xl
wb_p = xlc.select_workbook("Select Piece List")
xlc.get_sheets(wb_p)
ws_sheets = xlc.ws_sheets
ws_details = xlc.ws_details
ws_test = xlc.ws_test

#CONNECT TO EXCEL
 #wb_b = xlc.select_workbook("Select BOM")
 #ws_b = xlc.select_worksheet(wb_b)


#READ DATA FROM EXCEL
 xl_read = Xl_Reader.new(ws_sheets)
 #xl_read = Xl_Reader.new(ws_details)
 raw_sheet_info = xl_read.get_info
 #xl_read.print_lines


#p raw_info

#FORMAT READ DATA
 form = Formatter.new(raw_sheet_info)
 form_info = form.form_data
 #p form_info
 #form.show_list
 #form.show_other

#SORT BOM DATA
  #sort_bom = Sorter_bom.new(form_info)
  #list = sort_bom.sort_bom_data
  #list2 = sort_bom.sort_lists_pages(list)
  #p list2

#p form_info

#WRITE DATA TO EXCEL
 #xl_write = Xl_Writer.new(ws_b)
 #xl_write.write_lines_down(list2[1], "A14")

 
#ADD DATA TO MODEL
 pop = Populator.new(form_info)
 rel = pop.rel
 #p rel

#rel.unitlist.each_value{|v|
  #puts v.name + '  ' + v.type.to_s
#}

#COUNT DATA IN MODEL
 count = Counter.new(rel)
 ct = count.count_parts
 puts
 puts "JOB COUNT"
 ct[1].each_pair{|a, b|
   puts "#{a}:  #{b}"
 }

fn = "C:/Count.csv"
f = File.open(fn, "w"){|f|
  ct[1].each_pair{|a, b|
   f.puts "#{a},#{b}"
 }
}
 #unitlist = count.sheet_count(rel.unitlist["48"])
 #unitlist.each_pair {|k, v|
   #puts "#{k} = #{v}"
 #}

#CREATE REPORT
 #rep = Reporter.new(rel)
 #report = rep.report_data

#PRINT TO CONSOLE
 #p_console = ConsolePrinter.new(report)
 #p_console.print_data



#PRINT REPORT IN EXCEL
#xl_print = Xl_printer.new(report)


gets