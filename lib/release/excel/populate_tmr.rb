require 'win32ole'
load "#{$DIR}/programs/release_count/SETUP/xl_connector.rb"
load "#{$DIR}/programs/release_count/SETUP/xl_reader.rb"
load "#{$DIR}/programs/release_count/SETUP/formatter.rb"
load "#{$DIR}/programs/release_count/SETUP/populator.rb"

load "#{$DIR}/programs/release_count/REPORTS/reporter.rb"
load "#{$DIR}/programs/release_count/TMR/tmr_creator.rb"

#INTRO

class Populate_TMR

	def initialize(job_no, release_label, ero_name, shoes)
		#CONNECT TO EXCEL
		# begin
			# puts
			# puts "NO!"
			# puts
			@xlc = Xl_Connector.new
			#@wb = @xlc.select_workbook("Please Select File", /ero/)
			@wb = @xlc.set_book(ero_name)
			@ws = @xlc.get_sheet("TMR Form (Print)")
			@job_no = job_no
			@release_label = release_label

			#LOAD MODEL
			@release = Release.new shoes
			#job_info = get_info
			@release.setup(@job_no, @release_label)
			@release = load_release(@release, @release.filename)
			 
			#RUN REPORT TOTAL PROGRAM
			@reporter = Reporter.new(shoes)
			@reporter.run
			@reporter.report_tmr

			#FILL IN BOM
			tmr_creator = TMR_Creator.new(@release, @reporter, @wb, @ws)
			tmr_creator.add_tmr_report
		# rescue
		# 	p $!
		# end		
	end
	
	def load_release(release, filename)
	  data = File.read(filename)
	  release = YAML.load(data)
	  puts "Release file was loaded"
	  puts
	  return release
	end
	
end
