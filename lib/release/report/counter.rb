class Counter

  attr_accessor  :sheet_ct
  attr_accessor  :job_ct
  attr_accessor  :ship_ct
  attr_accessor  :sheets

  def initialize(rel)
    @rel = rel
    @unitlist = rel.unitlist.clone
    @sheets = {}
  end
  
  def count_parts
    a_of_h = get_sheets #hash of sheet names and ids
    @sheets = a_of_h[0]
    a = run_count(@sheets) #array[sheet_array[hash_parts{name => qty}]] totals by sheet
    b = rel_count(a) #release parts totals (1) hash
    c = ship_count(a) #release ship loose parts totals (1) hash
    #p a
    #p b
    return [a, b, c]
  end

  def run_count(sheets)
    answer = []
    sheets.each_pair{|k, v|
      c = sheet_count(v)
      s = sheet_ship_count(v)
      answer << [k, c, s]
    }
    @sheet_ct = answer
    return answer
  end

  def get_sheets
    answer = []
    sheets = {}
    rest = {}
    @unitlist.each_pair{|unit, id|
      if id.type == :sheet
      then sheets[unit] = id
      else rest[unit] = id
      end
    }
    answer = [sheets, rest]
    return answer
  end

  def sheet_count(sheet)
    answer = {}
    kids = sheet.children
    do_count(answer, kids, 1)
    return answer
  end

  def do_count(new_hash, hash, i)
    if i == nil then i = 1 end
    hash.each_pair{|k, v|
      v2 = v * i
      unless @rel.unitlist[k].children.empty?
        do_count(new_hash, @rel.unitlist[k].children, v2)
      end
      if new_hash.has_key?(k)
        v3 = v2 + new_hash[k]
      else v3 = v2
      end
      new_hash[k]= v3
    }
  end

  def sheet_ship_count(sheet)
    answer = {}
    do_count_ship(answer, sheet, 1)
    #do_count_ship_newish(answer, sheet, 1)
    return answer
  end

  def do_count_ship(new_hash, parent, i)
    if i == nil then i = 1 end
      parent.ship_loose.each_pair do |unit, qty|
        if new_hash.has_key?(unit)
          value = (qty * i) + new_hash[unit]
        else value = (qty * i)
        end
        new_hash[unit] = value
      end
      unless @rel.unitlist[parent.name].children.empty?
        parent.children.each_pair do |unit, qty|
          do_count_ship(new_hash, @rel.unitlist[unit], (qty * i))
      end
    end
  end

  def rel_count(sheet_ct)
    hash = {}
    ct = sheet_ct.clone
    ct.each {|h|
      add_to(h, hash, 1)
    }
    @job_ct = hash
    return hash
  end

  def ship_count(sheet_ct)
    hash = {}
    ct = sheet_ct.clone
    ct.each {|h|
      add_to(h, hash, 2)
    }
    @ship_ct = hash
    #p hash 
    return hash
  end

  def add_to(ct, hash, i) #[sheet name, {release count hash}, {ship count hash}]
    #THIS DETAIL MERGES AND ADD DUPLICATE NAMED ITEMS
    ct[i].each_pair{|k, v|
      if hash.has_key?(k)
      then hash[k] = hash[k] + v
      else hash [k] = v
      end
    }
  end

end