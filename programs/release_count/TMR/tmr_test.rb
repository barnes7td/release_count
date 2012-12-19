require 'win32ole'

load "#{$DIR}/programs/release_count/SETUP/xl_connector.rb"

class TMR_populator

	def intialize
		@ero = Xl_Connector.new
		@tmr = ero.get_sheet("TMR Form (Print)")

		@list = [[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[2, "stock"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[1, "part"],
						[2, "stock"],
						[1, "part"],
						[2, "stock"],
						[1, "part"],
						[1, "part"],
						[1, "part"]]

		populate_tmr
	end

	def populate_tmr()
		length = @list.length
		index = 0
		@cell = @tmr.range('A10')
		25.times do
			@cell.value = @list[index][0]
			@cell = @cell.offset(0, 3)
			@cell.value = @list[index][1]
			@cell = @cell.offset(-3, 1)
		end
	end

end

TMR_populator.new

			