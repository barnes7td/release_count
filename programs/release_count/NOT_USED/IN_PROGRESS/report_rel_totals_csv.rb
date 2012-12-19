
require 'REPORT/counter'


def report_job_total_csv(rel)
  #COUNT DATA IN MODEL
  count = Counter.new(rel)
  ct = count.count_parts
  puts
  puts "JOB COUNT"
  ct[1].each_pair{|a, b|
    puts "#{a}:  #{b}"
  }

  #PUT IN CSV_WRITER.RB FILE
  fn = "C:/Count.csv"
  f = File.open(fn, "w"){|f|
    ct[1].each_pair{|a, b|
      f.puts "#{a},#{b}"
    }
  }
end

def report_sheet_total_csv(rel)
  #COUNT DATA IN MODEL
  count = Counter.new(rel)
  count.count_parts
  ct = count.sheet_ct
  p ct

  types = [:post, :picket, :detail]

  ct.each{|sheet|
    puts "Sheet: #{sheet[0]}"
    types.each{|t|
      sheet[1].each_pair{|unit, qty|
        if rel.unitlist[unit].type == t
          puts "#{unit} = #{qty}"
        end
      }
    }
    puts
  }
  
  fn = "C:/Count_Sheets.csv"
  f = File.open(fn, "w"){|f|
    ct.each{|sheet|
      f.puts "Sheet: #{sheet[0]}"
      types.each{|t|
        sheet[1].each_pair{|unit, qty|
          if rel.unitlist[unit].type == t
           f.puts "#{unit} = #{qty}"
          end
        }
      }
      f.puts
    }
  }




end

def test_type(type, a_types)
  if a_types[type].include?
  then return true
  else return false
  end
end