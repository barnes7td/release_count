## THIS FILE HOLDS OLD METHODS FOR THE REPORTER.RB FILE

#COUNT RELEASE
def report_job_total_txt
  types = [:post, :picket, :detail, :insert]

  puts
  puts "RELEASE COUNT"
  types.each{|t|
    @count[1].each_pair{|unit, qty|
      if @rel.unitlist[unit].type == t
        puts "#{unit} = #{qty}"
      end
    }
  }
  puts
  puts "END OF RELEASE COUNT"

  #PUT IN CSV_WRITER.RB FILE
  fn = "C:/Release_Count/Count_Data/Count_Release.txt"
  file = File.open(fn, "w"){|f|
    f.puts @title
    f.puts "RELEASE COUNT"
    f.puts
    types.each{|t|
      @count[1].each_pair{|unit, qty|
        if @rel.unitlist[unit].type == t
          f.puts "#{unit} = #{qty}"
        end
      }
    }
  }
end

#RAIL LIST
def report_rails
    list = {}
    type = :rail_panel
    array = [list = {}]

    fn = "C:/Release_Count/Count_Data/Rail_List.txt"
    file = File.open(fn, "w"){|f|
      f.puts @title
      @count[1].each_pair{|unit, qty|
        if @rel.unitlist[unit].type == type
          unit = @rel.unitlist[unit]
          name = unit.name
          if list.has_key?(qty)
            list[qty]<< name
          else array = []
            array << name
            list[qty]= array
          end
        end
      }
      list.each_pair {|q, r|
        f.puts q.to_s + ' EA.'
        #r.sort!
        r.each{|ra|
          f.print ra + ', '
        }
        f.puts
        f.puts
      }
    }
  end

  #SHIP LOOSE LIST ORIGINAL (1)
  def report_ship_loose
    fn = "C:/Release_Count/Count_Data/Ship_Loose_List.txt"
    File.open(fn, "w"){|f|
      f.puts @title
      @types.each{|type|
        f.puts "#{type.upcase}:"
        @count[2].each_pair{|name, qty|
          if @rel.unitlist[name].type == type
            f.puts "#{name} = #{qty}"
          end
        }
        f.puts
      }
    }
  end
