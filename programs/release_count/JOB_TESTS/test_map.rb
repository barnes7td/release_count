class MapTester

	def initialize(formatted_data)
		@data = formatted_data  #[parent, name, type, qty, ship_loose]
		run_tests
	end

	def run_tests
		validate_data
	end

	def validate_data
		@data.each{|item|
			item[0]
			item[1]
			item[2]
			item[3]
			item[4]
		}
	end

end
