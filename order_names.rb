class Label
  attr_accessor :criteria, :text

  def initialize(text)
    @text = text
    @criteria = []
    find_criteria
  end

  def find_criteria
  	index = 0
  	text = @text.gsub(/\W/, "")

  	while index != nil
  		index = 0
      if /[#]/.match(text[index])
        @criteria << " "
        index += 1
	  	elsif /\d/.match(text[index])
	  		@criteria << /\d+/.match(text).to_s.to_i
	  		index = /\D+/ =~ text
	  	else @criteria << /\D+/.match(text).to_s
	  		index = /\d+/ =~ text
	  	end
      # p text[index] unless index == nil
      # p index unless index == nil
	  	text = text[index..20] unless index == nil
      # p text
      # p @criteria
	  end
  end

	def show
		puts @text
	end
end

class LabelSorter
  def sort_array(arr)
    p arr
    labels = arr.map{|label| Label.new label}
    ordered_labels = labels.sort_by{ |x| x.criteria }
    new_arr = []
    ordered_labels.each do |label|
      new_arr << label.text
    end
    new_arr
  end

  def sort_hash(hsh)
    p hsh
    arr = hsh.keys
    puts
    p arr
    labels = arr.map{|label| Label.new label}
    puts
    p labels
    ordered_labels = labels.sort_by{ |x| x.criteria }
    new_hsh = {}
    ordered_labels.each do |label|
      new_hsh[label.text] = hsh[label.text]
    end
    new_hsh
  end

  def sort_hash_text(hsh)
    new_hsh = {}
    arr = hsh.keys
    arr.sort!
    arr.each do |text|
      new_hsh[text] = hsh[text]
    end
    new_hsh
  end
end

a1 = ["1B1a", "1A2b", "10A1a", "2A1d", "10A1b" ]
h1 = {"1B1a" => 5, "1A2b" => 7, "10A1a" => 9, "2A1d" => 15, "10A1b" => 4 }

a2 = ["1'B.1a", "1(A)-2b", "#10\ A1a", "2A'1d", "1-0A1b" ]

h2 = {"1/2\" X 6\" ALUM. PLATE X 6\" LG."=>4, "1/4\" X 4\" ALUM BAR X 24'-0\" LG."=>7, "2\" X 2\" X 1/8\" ALUM. ANGLE X 4\" LG."=>16, "15/16\" ALUM. SIDE MT BRKT. X 5 5/8\" LG."=>32, 
      "3/8\" X 2 1/2\" ALUM. BAR X 5 5/8\" LG."=>32, "STD. ALUM. KICK PLATE BRKT. X 1 3/4\" LG."=>32, "1.45\" ALUM. RIBBED TUBE STIFFNER X 4\" LG."=>24, "3/8\" X 6\" ALUM. PLATE X 9\" LG."=>30, 
      "2\" (SCH 80) ALUM. PIPE X 5 5/8\" LG."=>30, "1/2\" SS THREADED ROD X 4 1/2\" LG.  (TYPE 316)"=>120, "3/16\" S.S. B.B.H. POP RIVET (TYPE 316)"=>72,
      "5/8\" HILTI QUIK BOLTS X 6\" LG. (TYPE 316)"=>8, "1/2\" S.S. H.H. MACHINE BOLT X 2\" LG. (TYPE 316)"=>128, "17 TEK-SCREWS X 1\" LG. (TYPE 316)"=>64, 
      "1/8\" S.S. B.B.H. POP RIVET (TYPE 316)"=>24, "1/2\" SS NUT and WASHER  (TYPE 316)"=>120, "10OZ EPOXY CARTRIDGE"=>120}


h3 = {"1/2\" X 6\" ALUM. PLATE X 6\" LG."=>4, "1/4\" X 4\" ALUM BAR X 24'-0\" LG."=>7, "1/2\" SS NUT & WASHER  (TYPE 316)"=>120}


test = ["/", ">", "#", "2", "&"]
p test.sort


# a2 = ["10A10B10C100", "10A10B10C2"]
# a3 = ["P-4", "P-2" ]

# a1.map! {|label| Label.new label}
# a2.map! {|label| Label.new label}
# a3.map! {|label| Label.new label}

# bl = lambda { |x| x.criteria }

# a1.sort_by!(&bl).each{|label| label.show}
# a2.sort_by!(&bl).each{|label| label.show}
# a3.sort_by!(&bl).each{|label| label.show}

# p a1.map! {|label| label.text}

ls = LabelSorter.new
# p ls.sort_array a1
puts
p ls.sort_hash_text h2
# puts
# p ls.sort_array a2