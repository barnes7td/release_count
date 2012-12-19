load "#{$DIR}/programs/release_count/MODEL/type_categories.rb"

class Formatter

  attr_accessor  :list_data
  attr_accessor  :form_data

  def initialize(data)#[header, lines]
    @data = data
    @header = data[0]
    @lines = data[1]
    @rel = @header[1]

    @type_cats = Type_Categories.new()
    @type_codes = @type_cats.codes

    @no_col = 5
    @parent = ["REL"]
    @list_data = []

    @form_data = format_data
  end

  def format_data
    h = @header
    new_list = filter_nil
    #new_list2 = update_cut_names(new_list)
    fd = decipher_list_data(new_list)
    a = [h, fd]
    return a
  end

  def update_cut_names(list)
    #TODO: PUT IN TYPE_CATEGORIES
    #adjust = ["RC", "B2", "B4", "B6", "BM"]
    rlist = []
    rline = []

    list.each{|line|
      rline = line
      if @type_cats.adjust_name.include?(@type_codes[line[2]])
      then name = parent.to_s + pm.to_s.downcase
      rline[1] = name
      end
      rlist << rline
    }
     return rlist
  end

  def filter_nil
    filter_data = []
    level = 0
    #parent = "REL"
    @lines.each{|line|
      data = []
      i = find_start(line)
      last = i + @no_col - 1
      level = i
      data << level
      data = data + line[i..last]
      filter_data << data
    }
    return filter_data
  end

  def find_start(array)
    i = 0
    level = 0
    until array[i] != nil
     level += 1
     i += 1
    end
    return i
  end


 ##########
  def decipher_list_data(lines)
    line_count = 0
    section = "Start"
    dec_data = []
    begin
    lines.each{|line|
        p = dec_parent(line)
        section = "Parent"
        dec_data << p[0]
        section = "Name"
        dec_data << dec_name(line, p[1])
        section = "Type"
        dec_data << dec_type(line)
        section = "Quantity"
        dec_data << dec_qty(line)
        section = "Ship Loose"
        dec_data << dec_ship_loose(line)
        @list_data << dec_data
        dec_data = []
        line_count += 1
    }
    rescue
      puts "Formatter broke at line #{line_count}"
      puts "Broke during section: #{section}"
      p $!
    end
    return @list_data
  end

  def dec_parent(dec_data)
    level = dec_data[0]
    i = level + 1
    @parent[i] = dec_name(dec_data, level)
    p = @parent[level]
    test = 1.0
    #p p.class == test.class
    p = p.to_i if p.class == test.class
    p = "REL" if p == nil
    return [p.to_s, level]
  end

  def dec_name(dec_data, level)
    test = 1.0
    #adjust = ["RC", "B2", "B4", "B6", "BM"]
    pm = dec_data[1]
    if pm != nil
      if @type_cats.adjust_name.include?(@type_codes[dec_data[2]])
      #if adjust.include?(dec_data[2])
      then pmb = @parent[level].to_s + pm.to_s.downcase
      else if pm.class == test.class
          pm = pm.to_i
        end
        pmb = pm.to_s.upcase
      end
    end
     return pmb.strip
  end

  def dec_type(dec_data)
    pt = dec_data[2].to_s.upcase
    @piece_type = @type_codes[pt]
    return @piece_type
  end

  def dec_qty(dec_data)
    q = dec_data[3].to_i
    return q.to_s.strip.to_i
  end

  def dec_ship_loose(dec_data)
    #puts dec_data.to_s
    ship = nil
    #puts dec_data[4].to_s
    if dec_data[4] != nil && dec_data[4].class != Float
      ship = dec_data[4].upcase.strip
    end
    if ship == "Y"
      q = dec_data[3].to_i
      return q.to_s.strip.to_i
    elsif dec_data[4].class == Float
      return dec_data[4].to_i
    elsif dec_data[4] == nil
      return nil
    end
  end

  

  ###########
  def show_list
    @list_data.each {|d|
      p d
    }
  end

  def show_other
    posts = []
    details = []
    @list_data.each {|d|
      test = d[3]
      case test
      when :post then posts << d[4]
      when :detail then details << d[4]
      end
    }
    p posts.uniq!.sort
    puts
    p details.uniq!.sort
  end

end