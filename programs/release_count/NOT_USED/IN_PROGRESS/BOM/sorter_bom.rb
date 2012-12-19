require 'release_class'

class Sorter_bom

  #attr_accessor  :list_data
  #attr_accessor  :form_data

  def initialize(data)#[header, lines]
    @data = data
    @header = data[0]
    @lines = data[1]
    @rel = @header[1]
  end

  def sort_bom_data
    @sorted_list = []
    posts = []
    rail_cuts = []
    bends2 = []
    bends4 = []
    bends6 = []
    #p @lines
    @lines.each {|d|
      #p d[3]
      test = d[3]
      case test
      when :post then posts << d[4]
      when :rail_cut then rail_cuts << d[4]
      when :bend2 then bends2 << d[4]
      when :bend4 then bends4 << d[4]
      when :bend6 then bends6 << d[4]
      end
    }
    puts "test"
    p rail_cuts
    p bends2
    p bends6
    puts
    @sorted_list << posts.uniq!.sort unless posts.empty?
    @sorted_list << rail_cuts unless rail_cuts.empty?
    @sorted_list << bends2 unless bends2.empty?
    @sorted_list << bends4 unless bends4.empty?
    @sorted_list << bends6 unless bends6.empty?

    return @sorted_list
  end

  def sort_lists_pages(list)
    sorted_page_list = []
    list.each {|a|
      s = add_spaces(a)
      p = sep_bom_pages(s)
      p p
      sorted_page_list << p
    }
    return sorted_page_list
  end

  def add_spaces(list)
    if list[0][0].chr == "P"
      return list
    else array = []
      test = nil
      list.each{|n|
        if test != nil
          if n[0...-1] != test
            array << nil
          end
        end
        array << n
        test = n[0...-1]
      }
      return array
    end
  end

  def sep_bom_pages(list)
    no_rows = 32
    a_units = no_rows - 1
    page_list = []
    length = list.length
    div = length / no_rows
    rem = length % no_rows
    if rem > 0
      div += 1
    end

    i = 0
    i2 = a_units

    div.times do
      page_list << list[i..i2]
      i += no_rows
      i2 += no_rows
    end

    return page_list
  end

  

end