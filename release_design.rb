require 'green_shoes'
require 'pathname'


Shoes.app :title => "Tuttle Release", :height => 820, :width => 700 do
	background lightblue
	#background white, :height => 80
	#background white...blue, :top => 80
	#background white, :height => 80

	#$DIR = Pathname.new(__FILE__).realpath.dirname.to_s
	
	stack :margin => 10 do
		#subtitle "Tuttle Release"
		image "./resources/TuttleLogo.png"

		flow do
			para "Job No:", :width => 100
			@job_no_display = para "-", :width => 100
			para "Release:", :width => 100
			@release_display = para "-", :width => 100
		end

		button "Set Release"

		para "Tools"
		
		flow do
			button "Start New Release" do
				start_release
			end
			
			button "Update Count" do
				Update_Count.new
			end
			
			button "Print BOM" do
				Populate_Bom.new(@data[0], @data[1])
			end
			
			button "Insert Cuts" do
				Insert_Cuts.new
			end
		end

			para "Reports"

		flow do
			button "Sheet Report" do
				filename = "#{@dir}Count_Sheets.txt"
				show_report(filename, @report_box)
				@current_report = :sheet
			end

			button "Detail Report" do
				filename = "#{@dir}Detail Breakdown.txt"
				show_report(filename, @report_box)
				@current_report = :detail
			end

			button "Release Report" do
				filename = "#{@dir}Release_List.txt"
				#puts filename
				show_report(filename, @report_box)
				@current_report = :release
			end

			button "Shipping Report" do
				filename = "#{@dir}Ship_Loose_List.txt"
				show_report(filename, @report_box)
				@current_report = :ship
			end
		end
		
		@report_box = edit_box :width => 580, :height => 500, :margin => 10
		
	end

	def setup
		@id = ID.new
		#@id.load
		p @id.data
		#unless @id.data == []
			@data = @id.data 
			@job_no = @data[0]
			@release = @data[1]
			@job_no_display.text = @job_no
			@release_display.text = @release
			@dir = set_dir(@job_no, @release, $DIR)
		#end
	end

	#setup

	def print
		filename = case @current_report
		when :sheet then "#{@dir}Count_Sheets.txt"
		when :detail then "#{@dir}Detail Breakdown.txt"
		when :release then "#{@dir}Release_List.txt"
		when :ship then "#{@dir}Ship_Loose_List.txt"
		end
		f = File.new(filename, r)
		f.print
	end
	

end

