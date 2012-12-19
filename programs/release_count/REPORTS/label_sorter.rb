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
    labels = arr.map{|label| Label.new label}
    ordered_labels = labels.sort_by{ |x| x.criteria }
    new_arr = []
    ordered_labels.each do |label|
      new_arr << label.text
    end
    new_arr
  end

  def sort_hash(hsh)
    arr = hsh.keys
    labels = arr.map{|label| Label.new label}
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