load "#{$DIR}/programs/release_count/SETUP/xl_connector.rb"
load "#{$DIR}/programs/release_count/SETUP/xl_reader.rb"
load "#{$DIR}/programs/release_count/SETUP/formatter.rb"
load "#{$DIR}/programs/release_count/SETUP/populator.rb"

load "#{$DIR}/programs/release_count/REPORTS/reporter.rb"
load "#{$DIR}/programs/release_count/BOM/bom_creator.rb"

#INTRO

class Populate_Bom

	def initialize(job_no, release_label, ero_name, shoes)
		@shoes = shoes
		# CONNECT TO EXCEL
		@xlc = Xl_Connector.new
		# @wb = @xlc.select_workbook("Please Select File", /ero/)
		@wb = @xlc.set_book(ero_name)
		@job_no = job_no
		@release_label = release_label

		# LOAD MODEL
		@release = Release.new
		# job_info = get_info
		@release.setup(@job_no, @release_label)
		@release = load_release(@release, @release.filename)
		 
		#RUN REPORT TOTAL PROGRAM
		@reporter = Reporter.new(@shoes)
		@reporter.run(@release)
		@reporter.report_bom_csv

		#FILL IN BOM
		puts "workbook:"
		puts @wb.name
		puts
		bom_creator = BOM_Creator.new(@release, @reporter, @wb)
		bom_creator.add_tabs
		bom_creator.add_marks		
	end
	
	def load_release(release, filename)
	  data = File.read(filename)
	  release = YAML.load(data)
	  puts "Release file was loaded"
	  puts
	  return release
	end
	
end
