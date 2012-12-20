class CutCalc

	def initialize(material_type, cut)
		@mat_type = material_type
	  @piece_no = cut[0]
	  @qty = cut[1]
	  @notes = cut[2]
	  @ship_loose = cut[3]
	  @feet = cut[4]
	  @inches = cut[5]
	  @bevel = cut[6]
	  @left_cut = cut[7]
	  @left_dir = cut[8]
	  @right_cut = cut[9]
	  @right_dir = cut[10]
	  @right_bevel = cut[11]
	  @extra = cut[12]
	  @less = cut[13]
	  @override = cut[14]

		@cut_types = []
		@mat_diameter = {"1 1/2 (SCH 40) ALUM PIPE" => 1.90, }

		unless @override
		  add_decimal_inches
		  add_left_difference
		  add_right_difference
		  adjust_for_addtional
		end
		@calc_cut = compile_info
	end

	def get_decimal_inches
		@length = (@feet * 12.0) + @inches
	end

	def miter(type, bevel)

	end

	def mill(type, bevel)
		
	end

	def forty_five(type, bevel)
		
	end

	def cope(type, bevel)
		
	end

	def follyhart(type, bevel)
		
	end

	def end_difference(cut_type, bevel)
		difference = 0.0
		add = case cut_type
		when :a then miter(:a, bevel)
		when :b then mill(:b, bevel)
		when :c then miter(a, bevel)
		when :d then miter(a, bevel)
		when :f4 then miter(a, bevel)
		when :f8 then miter(a, bevel)
		when :f2 then miter(a, bevel)
		when :h then forty_five(:h)
		when :m45 then forty_five(:m45)
		when :e then cope
		when :e3 then cope
		when :y then follyhart
		when :q then 0.0
		#when :sp
		end

		difference += add
	end

	def add_left_difference
		difference = end_difference(@left_cut, @bevel)
		@length += difference
	end

	def add_right_difference
		if @right_bevel
			bevel = @bevel
		else bevel = @right_bevel
		end
		difference = end_difference(@right_cut, bevel)
		@length += difference
	end

	def add_additional
		@length += @extra
		@length -+ @less
	end

	def compile_info
	end


end
