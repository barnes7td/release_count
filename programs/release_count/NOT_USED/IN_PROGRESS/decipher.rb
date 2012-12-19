# To change this template, choose Tools | Templates
# and open the template in the editor.

class Decipher

  def initialize(rel)
    @rel = rel
    @sheet_no = nil
    @rail_no = nil
    @rail_qty = 0
  end

  def decipher_sheet_data(data)
    dec_data = []
    data.each{|line|
      dec_data << dec_sheet_no(line)
      dec_data << dec_rail_no(line)
      dec_data << dec_rail_qty(line)
      dec_data << dec_piece_mk(line)
      dec_data << dec_piece_type(line)
      dec_data << dec_piec_qty(line)
      p dec_data
      #update_model(dec_data)
      dec_data = []
    }
  end

  def dec_sheet_no(dec_data)
    sn = dec_data[0]
    if sn != nil
      @sheet_no = sn.to_i.to_s
    end
    return @sheet_no
  end

  def dec_rail_no(dec_data)
    rn = dec_data[1]
    if rn != nil
      then rnb = @sheet_no + @rel + rn.to_i.to_s
        @rail_no = rnb
        return rnb
      else return @rail_no
    end
  end

  def dec_rail_qty(dec_data)
    rq = dec_data[2].to_i
  end

  def dec_piece_mk(dec_data)
    pm = dec_data[3]
    if pm != nil
      pmb = @rail_no + pm.to_s.downcase
    end
     return pmb
  end

  def dec_piece_type(dec_data)
    pt = dec_data[4].to_s.upcase
    type = case pt
      when "2.0" then :bend2
      when "4.0" then :bend4
      when "6.0" then :bend6
      when "R" then :railcut
    end
    return type
  end

  def dec_piec_qty(dec_data)
    pq = dec_data[5].to_i
  end

end