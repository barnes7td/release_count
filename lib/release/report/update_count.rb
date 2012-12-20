
class UpdateCount
	attr_reader :wb_name

def initialize(rel)
	@rel = rel

	load "#{@rel.program_directory}/lib/release/excel/xl_connector.rb"
	load "#{@rel.program_directory}/lib/release/excel/xl_reader.rb"
	load "#{@rel.program_directory}/lib/release/formatter.rb"
	load "#{@rel.program_directory}/lib/release/populator.rb"

	load "#{@rel.program_directory}/lib/release/excel/writer/bom_creator.rb"
	load "#{@rel.program_directory}/lib/release/validation/test_data.rb"
end

def run(wb_name)
	error_report = ""
	connect wb_name
	get_list_sheets
	maps = []
	error_report << "~~~~~~~~~ ERROR REPORT ~~~~~~~~~\n\n"
	@list_sheets.each do |ls|
		maps << collect_data(ls, error_report)
		error_report << "\n"
	end
	error_report << "~~~~~~~~~ END OF REPORT ~~~~~~~~~\n\n\n"
	map = merge_maps maps # [sheet, post, details, sections]
	run_count(map)
	@rel.run_reports
	error_report << updated_time
	@shoes.report error_report

end

# def shoes_report(text)
# 	@shoes.report text
# end

def merge_maps(maps)
	full_map = []
	maps.each do |m|
		unless m == nil
			if full_map.empty?
			  full_map = m
			else full_map[1] = full_map[1].concat m[1]
			end
		end
	end

	return full_map
end

def connect(wb_name)
	#CONNECT TO EXCEL
	@xlc = Xl_Connector.new
	wb = @xlc.set_book(wb_name)
	puts "Connected to #{wb.name}"
	# @xlc.select_workbook("Please Select File", /piece list/)
end

def get_list_sheets
	@list_sheets = []
	@xlc.wb.Worksheets.each do |ws|
		@list_sheets << ws.name if /list/ =~ ws.name.downcase
	end
end

def collect_data(tab_name, error_report)
	unless @xlc.get_sheet(tab_name) == nil
		ws_sheet = @xlc.get_sheet(tab_name)
		#READ DATA FROM EXCEL
		xl_read = Xl_Reader.new(ws_sheet)
		raw_sheet_info = xl_read.get_info
		#FORMAT READ DATA
		formatter = Formatter.new(raw_sheet_info, @rel)
		form_info = formatter.form_data
		#TEST DATA
		data_tester = DataTester.new(form_info[1], tab_name, @rel)
		error_report << "#{tab_name} Error Report:"
		error_report << "\n"
		if data_tester.error_report.length == 0
	   error_report << "  No errors were found"
	   error_report << "\n"
		else data_tester.error_report.each{|report| error_report << report}
		end

		return form_info
	end
end

def run_count(map)
	#ADD DATA TO MODEL
	Populator.new(map, @rel)
end

def updated_time
	"Updated at:  #{Time.now.strftime("%l:%M:%S %P on %b %-d, %Y")}"
end

end
