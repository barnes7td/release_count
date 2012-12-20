require 'win32ole'

load "#{$DIR}/programs/release_count/REPORTS/label_sorter.rb"

class Sorter_bom

  #attr_accessor  :list_data
  #attr_accessor  :form_data

  def initialize(data, types, job_type)
    @types = types
    @data = data #[[unit, qty, type], [unit, qty, type]]
    @job_type = job_type
  end

  def sort_bom_data
    @sorted_list = []
    type_hash = {}
    @types.each {|t|
      type_hash[t] = []
    }
    @data.each {|d|
      type_hash[d[2]] << [d[0], d[1]]
    }
    #Uses string.sort, which is not adequate for sorting
    hash = sort_types type_hash # {type => [ [name, qty], [name, qty] ]}
    return hash #hash when revised
  end

  #Uses string.sort, which is not adequate for sorting
  def sort_types(hash)
    new_hash = {}
    hash.each_pair do |type, array_units|

      #TODO
      #data = sort_names array_units
      data = array_units
      
      new_hash[type] = data
    end
    return new_hash
  end

  def sort_names_new(array)
    sorted = LabelSorter.new(array)
  end

  #Uses string.sort, which is not adequate for sorting
  def sort_names_old(array_units)
    list = []
    hash = {}
    data = []
    array_units.each do |a|
      hash[a[0]] = a[1]
      list << a[0]
    end
    list.sort!{|x, y| /\d+/.match(x).to_s.to_i <=> /\d+/.match(y).to_s.to_i} #need to fix if have "10a10", "2A1"
    p list
    list.each do |name|
      data << [name, hash[name]]
    end
    p data
    return data
  end

  def sort_list_pages(list)
    revised_hash = {}
    sorted_page_list = []
    list.each_pair{ |t, m|
      s = add_spaces(m)
      pages = sep_bom_pages(s)
      #p pages
      sorted_page_list << pages
      revised_hash[t] = sorted_page_list
      sorted_page_list = []
    }
    return revised_hash
  end

  def add_spaces(list)
    # p list
    # puts "list[0][0][0].chr = #{list[0][0][0].chr}"
    # if list[0][0][0].chr == "P"
    #   return list
    # else array = []
    array = []
    test = nil
    list.each{|n|
      if test != nil
        if n[0][0...-1] != test
          array << nil
        end
      end
      array << n
      test = n[0][0...-1]
    }
    return array
    # end
  end

  def sep_bom_pages(list)
    if @job_type == "Welded BOM"
      no_rows = 32
    else no_rows = 41
    end
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

  def create_boms(hash, wb)
    hash.each_pair{|type, pages|
      ws = wb.Worksheets(type.to_s.upcase + " BOM")
      input_sheets(ws, pages)
    }
  end

  def input_sheets(ws, array)
    page_index = 0
    if @job_type == "Welded BOM"
      page_offset = 41
    else page_offset = 50
    end
    range = ws.range("A14")
    no_pages = array[page_index].length
    puts no_pages.to_s
    no_pages.times do
      input_sheet(array[0], range, page_index)
      range = range.offset(page_offset,0)
      page_index += 1
    end
  end

  def input_sheet(page, range, index)
    page[index].each {|line|
      range.value = line[0].to_s unless line == nil
      range = range.offset(0,1)
      range.value = line[1].to_s unless line == nil
      range = range.offset(1,-1)
    }
  end

end