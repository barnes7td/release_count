
class Formatter

  attr_accessor  :list_data
  attr_accessor  :form_data

  def initialize(data)#[header, lines]
    @data = data
    @header = data[0]
    @lines = data[1]
    @rel = @header[1]

    @sheet_no = nil
    @sheet_origin = nil
    @rail_no = nil
    @rail_qty = 0
    @piece_type = nil
    @label = nil
    @list_data = []

    @form_data = format_data
  end

  def format_data
    h = @header
    fd = decipher_list_data
    a = [h, fd]
    return a
  end

  def decipher_list_data
    dec_data = []
    @lines.each{|line|
      unless line[6] == nil
        dec_data << dec_sheet_no(line)
        dec_sheet_origin(line)
        add_general(line)
        dec_data << dec_rail_no(add_general(line))
        dec_data << dec_rail_qty(line)
        dec_data << dec_piece_type(line)
        dec_data << dec_piece_mk(line)
        dec_data << dec_piece_qty(line)
        @list_data << dec_data
        dec_data = []
      end
    }
    return @list_data
  end

  def dec_sheet_no(dec_data)
    sn = dec_data[0]
    if sn != nil
      @sheet_no = sn.to_i.to_s
    end
    return @sheet_no
  end

  def dec_sheet_origin(dec_data)
    so = dec_data[1]
    if so != nil
      @sheet_origin = so.to_i.to_s
    end
    return @sheet_origin
  end

  def add_general(dec_data)
    test = dec_data[5].to_s.upcase
    extra = ["P", "D"]
    if extra.include?(test)
      dec_data[2] = "G"
    end
    return dec_data
  end
  
  def dec_rail_no(dec_data)
    rn = dec_data[2]
    if rn == nil
    then return @rail_no
    else rn = rn.upcase if rn.class == String
         if rn == "G"
         then @label = :collective
          return @rail_no
         else #p @sheet_origin
          #p @rel
          #p dec_data[2]
          #p @rn
          rnb = @sheet_origin + @rel + rn.to_i.to_s
          @rail_no = rnb
          @label = :individual
          return rnb
         end
    end
  end

  def dec_rail_qty(dec_data)
    rq = dec_data[3].to_i
    return rq
  end

  def dec_piece_mk(dec_data)
    pm = dec_data[4]
    if pm != nil
      if @label == :individual
      then pmb = @rail_no + pm.to_s.downcase
      else pmb = pm.to_s.upcase
      end
    end
     return pmb.strip
  end

  def dec_piece_type(dec_data)
    pt = dec_data[5].to_s.upcase
    type = case pt
      when "2.0" then :bend2
      when "4.0" then :bend4
      when "6.0" then :bend6
      when "R" then :rail_cut
      when "D" then :detail
      when "P" then :post
      when "T" then :picket
    end
    @piece_type = type
    return type
  end

  def dec_piece_qty(dec_data)
    pq = dec_data[6].to_i
  end

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