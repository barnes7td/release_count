require 'win32ole'
load "#{$DIR}/programs/release_count/SETUP/xl_connector.rb"

class Insert_Cuts

	def get_group_cell(value, direction)
		if direction == :left
			answer = case value
				when "SQ" then "B2"
				when "T ML" then "B3"
				when "B ML" then "B4"
				when "T MT" then "B5"
				when "B MT" then "B6"
				when "N MT" then "B7"
				when "F MT" then "B8"
				when "T CP" then "B9"
				when "S CP" then "B10"
				when "F HT" then "B11"
				when "N HT" then "B12"
				when "T 3C" then "B13"
				when "B 3C" then "B14"
				else nil
			end #-case
			return answer
		elsif direction == :right
			answer = case value
				when "SQ" then "C2"
				when "T ML" then "C3"
				when "B ML" then "C4"
				when "T MT" then "C5"
				when "B MT" then "C6"
				when "N MT" then "C7"
				when "F MT" then "C8"
				when "T CP" then "C9"
				when "S CP" then "C10"
				when "F HT" then "C11"
				when "N HT" then "C12"
				when "T 3C" then "C13"
				when "B 3C" then "C14"
				else nil
			end #-case
			return answer
		end #-if
	end #-def

		
		def paste_to_bom(cell_address, ws_copy, ws_paste, range)
			if cell_address != nil 
			then
				copy_cell = ws_copy.range(cell_address)
				copy_cell.copy
				ws_paste.Activate
				range.Select
				ws_paste.Paste
			else
				ws_paste.Activate
				range.Select
			end
		end
			
	###--SELECT WORKBOOK AND WORKSHEET--###
	def initialize
		begin #-error check
			xlc = Xl_Connector.new
			excel = xlc.xl
			wbBOM = excel.activeworkbook
			wbWCC = excel.Workbooks.Open('S:\Engineering\Eng_WorkFiles\Excel Templates\CutsCopy.xlsx')
			wsWCC = wbWCC.Worksheets('Welded BOM')

			# wbBOM = xlc.select_workbook("Please Select File", /ero/)
			wbBOM.Activate
			wsBOM = excel.Activesheet

			puts "Active Workbook is #{wbBOM.name}"
			puts "Active WorkSheet is #{wsBOM.name}"

			puts "Is this correct? y/n"
			answer = gets.chomp.downcase

			case answer
			when "y" then puts "Inserting cuts"
			when "n" then puts "Select the correct sheet, then press ENTER"
				gets
				wbBOM = excel.activeworkbooK
				wsBOM = excel.activesheet
			else raise
			end
			
		###--INSERT CUTS START--###
		print_area = wsBOM.pagesetup.printarea

		no_rows = case wsBOM
		when "MECHANICAL BOM TAB SETTINGS" then 49
		when "WELDED BOM TAB SETTINGS" then 40
		else 40
		end

		no_arr = print_area.scan(/\d+/)
		total_rows = no_arr[1].to_i - no_arr[0].to_i
		pages = total_rows / no_rows

		range = excel.range("H14")

		pages.times do
		i = 0
			while i < 32 do
				###--LEFT SIDE--###
				vGetValue = range.value
				copy_cell_address = get_group_cell(vGetValue, :left)
				paste_to_bom(copy_cell_address, wsWCC, wsBOM, range)  
				
				Kernel::sleep 0.01
				range = range.offset(0,1)
				range.Select


				###--RIGHT SIDE--###
				vGetValue = range.value
				copy_cell_address = get_group_cell(vGetValue, :right)
				paste_to_bom(copy_cell_address, wsWCC, wsBOM, range)

				Kernel::sleep 0.01
				range = range.offset(1,-1)
				range.Select

				i = i + 1
			end #while
			range = range.offset(9,0)
			range.Select
		end #times

		###--FINISH ERROR CHECKING--###
		rescue
		 p $!
		 
		ensure
		 
		end #-begin
	end
end #-class
