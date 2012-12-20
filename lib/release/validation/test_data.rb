load "#{$DIR}/programs/release_count/MODEL/type_categories.rb"

class DataTester

	attr_reader :error_report

	def initialize(formatted_data, tab_name)
		@tab_name = tab_name
		@error_report = []
		@data = formatted_data  #[parent, name, type, qty, ship_loose]
		@type_cats = Type_Categories.new
		@first_piece_list_map_line = 7
		run_tests
	end

	def run_tests
		validate_data
	end

	def validate_data
		count = @first_piece_list_map_line
		@data.each do |item|
			validate_parent(item, count)
			validate_name(item, count)
			validate_type(item, count)
			validate_qty(item, count) #SEND ZERO QTY'S WITH NEW INPUT DESIGN, REVIEW NEW SOLUTION IN FUTURE
			validate_ship(item, count)
			count += 1
		end
	end

	def create_error(count, item, description)
		"(#{@tab_name}: #{count}) #{item[1]}: #{description}"
	end

	def validate_parent(item, count)
		parent = item[0]
		type = item[2]
		if parent == nil
			@error_report << create_error(count, item, "does not have a parent")
		end
		if parent == "REL" && type != :sheet
			@error_report << create_error(count, item, "does not have the right parent")
		end

	end

	def validate_name(item, count)
		name = item[1]
		if name == nil
			@error_report << "Item No. #{count} does not have a name. parent: #{item[0]}"
		end
	end

	def validate_type(item, count)
		type = item[2]
		if type == nil
			@error_report << "(#{@tab_name}: #{count}) #{item[0]}_#{item[1]}: does not have a type"
		end
		unless @type_cats.types.include?(type)
			@error_report << "(#{@tab_name}: #{count}) #{item[0]}_#{item[1]}'s type is not a valid type"
		end
	end

	def validate_qty(item, count)
		qty = item[3]
		type = item[2]
		name = item[1]
		if qty == nil
			@error_report << "(#{@tab_name}: #{count}) #{item[0]}_#{item[1]}: does not have a qty"
		elsif qty.to_i == 0 && type != :sheet && !(@tab_name =~ /#{type.to_s.upcase}/)
			@error_report << "(#{@tab_name}: #{count}) #{item[0]}_#{item[1]}'s quantity is zero or not valid"
		end
	end

	def validate_ship(item, count)
		qty = item[3]
		ship_loose = item[4]
		#HAS NUMBER NOT "Y"
		unless ship_loose == nil
			if ship_loose > qty
				@error_report << "(#{@tab_name}: #{count}) #{item[1]}: Too many shipped loose"
			end
		end
	end


end
