require 'yaml'

class ID

	attr_accessor :data

	def initialize(shoes)
		@filename = "#{$DIR}/lib/data.yml"
		@data = []
	end

	def save
		File.open(@filename, "w"){|f|
			YAML.dump(@data, f)
		}
	end

	def load_data
		File.open(@filename, "r"){|f|
			 @data = YAML.load(f)
		}
	end

end