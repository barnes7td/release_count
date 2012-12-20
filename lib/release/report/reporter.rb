require 'erb'

load "#{$DIR}/programs/release_count/REPORTS/counter.rb"
load "#{$DIR}/programs/release_count/REPORTS/label_sorter.rb"

class Reporter

  attr_reader  :count
  attr_reader  :bom
  attr_reader  :tmr

  def initialize(shoes)
    @shoes = shoes
  end

  def run(rel)
    @counter = Counter.new(rel)
    @count = @counter.count_parts
    @rel = rel
    @type_cats = @rel.type_cats
    @types = @type_cats.types
    @sheets = get_sheets
    @title = "RELEASE: #{@rel.jobno.to_s + @rel.releaselabel.to_s}"
    @jobno = @rel.jobno.to_s
    @dir = @rel.directory
    @template_dir = "#{$DIR}/programs/release_count/REPORTS/report_templates"
    @sorter = LabelSorter.new
  end

  def set_dir
    unless File.exists?(@dir)
      Dir.mkdir(@dir)
    end
  end

  def get_types
    array = []
    @rel.unitlist.each_value{|u|
      type = u.type
      if array.include?(type)
      else array << type
      end
    }
    return array
  end

  def get_sheets
     sh_array = []
     @counter.sheets.each{|sheet|
        sh_array << sheet[0]
        sh_array.sort!
      }
      return sh_array
  end

  def test_type(type, a_types)
    if a_types[type].include?
    then return true
    else return false
    end
  end

  #RELEASE LIST
  def report_release_list
    array = []
    report_name = "Release_List.txt"
    fn = @dir + report_name
    File.open(fn, "w"){|f|
      f.puts @title
      f.puts "RELEASE LIST"
      f.puts
      f.puts "Sheets:"
      @sheets.each{|sheet|
        f.puts sheet.to_s
      }
      puts
      @types.each{|t|
        hash = {}
        @count[1].each_pair{|unit, qty|
          if @rel.unitlist[unit].type == t
            hash[unit] = qty
          end
        }
        ##
        unless hash.empty?
          f.puts
          f.puts t.to_s.upcase + ":"
          hash.each_pair{|u, q|
            f.puts "#{u} = #{q}"
          }
        end
        
      }
    }
   end

  #COUNT SHEETS
  def report_sheet_total_txt
    ct = @counter.sheet_ct
    types = @type_cats.sheet_total

    report_name = "Count_Sheets.txt"
    fn = @dir + report_name
    File.open(fn, "w"){|f|
      f.puts @title
      f.puts "SHEET COUNTS"
      f.puts
      ct.each{|sheet|
        f.puts "Sheet: #{sheet[0]}"
        types.each{|t|
          sheet[1].each_pair{|unit, qty|
            if @rel.unitlist[unit].type == t
             f.puts "#{unit} = #{qty}"
            end
          }
        }
        f.puts
      }
    }
  end

  #TMR.txt

  #BOM.csv
  def report_bom_csv
    types = @type_cats.bom
    @bom = []
    #@bom = {}

    report_name = "BOM.csv"
    fn = @dir + report_name
    File.open(fn, "w"){|f|
      types.each{|t|
        @count[1].each_pair{|unit, qty|
          if @rel.unitlist[unit].type == t
            f.puts "#{unit},#{qty},#{@rel.unitlist[unit].type}"
            @bom << [unit, qty, @rel.unitlist[unit].type]
            #@bom[unit] = [qty, @rel.unitlist[unit].type]
          end
        }
      }
    }
    #p @bom
  end

  #SHIP LOOSE LIST (2)
  def report_ship_loose
    #p @count[1]
    #p @count[2]
    ea_types = [:rail_panel, :post, :bend_custom, :rail, :panel]
    report_name = "Ship_Loose_List.txt"
    fn = @dir + report_name
    File.open(fn, "w"){|f|
      f.puts @title
      f.puts
      @types.each{|type|
        list = {}
        array = [list = {}]
        @count[2].each_pair{|unit, qty|
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
        unless list.empty?
          f.puts "#{type.to_s.upcase}:"
          #if type == :rail_panel
          if ea_types.include? type
            list.each_pair {|q, r|
              f.print q.to_s + ' EA: '
              #r.sort!
              r.each{|ra|
                f.print ra + ', '
              }
              f.puts
            }
          else
            list.each_pair {|q, r|
              r.each{|ra|
                f.print "(#{q.to_s})  "
                f.puts ra
                f.puts
              }
            }
          end
          f.puts
          f.puts
        end
      }
    }
  end

  #DETAIL BREAKDOWN
  def report_detail_breakdown
    types = [:detail, :kp_detail]

    report_name = "Detail Breakdown.txt"
    fn = @dir + report_name
    File.open(fn, "w"){|f|
      f.puts @title
      f.puts
      types.each{|t|
        @count[1].each_pair{|unit, qty|
        #@counter.ship_ct.each_pair{|unit, qty|
          if @rel.unitlist[unit].type == t
            #f.print "#{@rel.unitlist[unit].name}: = #{qty}"
            f.print "#{unit} (#{qty})"
            f.puts
            @rel.unitlist[unit].children.each_pair{|child, qty2|
              s_l = @rel.unitlist[unit].ship_loose[@rel.unitlist[child].name]
              f.print "  (#{(qty.to_i * qty2.to_i).to_s}) [X #{qty2}]  #{child}" # {@count[1][child]}
              f.print "  ##[S/L: #{s_l}]" unless s_l == nil
              f.puts
            }
            f.puts
          end
          #f.puts
        }
        f.puts
        f.puts
      }
    }
  end

  #TOTAL MATERIAL REPORT (TMR)
  def report_tmr
    types = @type_cats.tmr
    @tmr = {}

    create_report("tmr_csv.erb", "TMR.csv", types, @tmr)
    @tmr = @sorter.sort_hash_text(@tmr)
    create_report("tmr_txt.erb", "TMR.txt", @tmr)
  end

  def create_report(template, report, *arr)
    variables = arr
    tmr_csv = ERB.new (File.read("#{@template_dir}/#{template}")).gsub(/^ *</, '<'), 0, "<>"
    #puts (File.read("#{@template_dir}/#{template}")).gsub(/^ *</, '<')
    File.write "#{@dir}#{report}", tmr_csv.result(binding)
  end


#POST BREAKDOWN
  def report_post_breakdown
    types = [:post]

    # report_name = "Post Breakdown.txt"
    # fn = @dir + report_name
    # @sorter.sort_array(types)
    create_report("post_txt.erb", "Post Breakdown.txt", types)

    # File.open(fn, "w"){|f|
    #   f.puts @title
    #   f.puts
    #   types.each{|t|
    #     @count[1].each_pair{|unit, qty|
    #     #@counter.ship_ct.each_pair{|unit, qty|
    #       if @rel.unitlist[unit].type == t
    #         #f.print "#{@rel.unitlist[unit].name}: = #{qty}"
    #         f.print "#{unit} (#{qty})"
    #         f.puts
    #         @rel.unitlist[unit].children.each_pair{|child, qty2|
    #           s_l = @rel.unitlist[unit].ship_loose[@rel.unitlist[child].name]
    #           f.print "  (#{(qty.to_i * qty2.to_i).to_s}) [X #{qty2}]  #{child}" # {@count[1][child]}
    #           f.print "  ##[S/L: #{s_l}]" unless s_l == nil
    #           f.puts
    #         }
    #         f.puts
    #       end
    #       #f.puts
    #     }
    #     f.puts
    #     f.puts
    #   }
    # }
  end

  #PANEL BREAKDOWN
  def report_panel_breakdown
    types = [:panel]

    report_name = "Panel Breakdown.txt"
    fn = @dir + report_name
    File.open(fn, "w"){|f|
      f.puts @title
      f.puts
      types.each{|t|
        @count[1].each_pair{|unit, qty|
        #@counter.ship_ct.each_pair{|unit, qty|
          if @rel.unitlist[unit].type == t
            #f.print "#{@rel.unitlist[unit].name}: = #{qty}"
            f.print "#{unit} (#{qty})"
            f.puts
            @rel.unitlist[unit].children.each_pair{|child, qty2|
              s_l = @rel.unitlist[unit].ship_loose[@rel.unitlist[child].name]
              f.print "  (#{(qty.to_i * qty2.to_i).to_s}) [X #{qty2}]  #{child}" # {@count[1][child]}
              f.print "  ##[S/L: #{s_l}]" unless s_l == nil
              f.puts
            }
            f.puts
          end
          #f.puts
        }
        f.puts
        f.puts
      }
    }
  end

  #GROUP BREAKDOWN
  def report_group_breakdown
    types = [:group]

    report_name = "Group Breakdown.txt"
    fn = @dir + report_name
    File.open(fn, "w"){|f|
      f.puts @title
      f.puts
      types.each{|t|
        @count[1].each_pair{|unit, qty|
        #@counter.ship_ct.each_pair{|unit, qty|
          if @rel.unitlist[unit].type == t
            #f.print "#{@rel.unitlist[unit].name}: = #{qty}"
            f.print "#{unit} (#{qty})"
            f.puts
            @rel.unitlist[unit].children.each_pair{|child, qty2|
              s_l = @rel.unitlist[unit].ship_loose[@rel.unitlist[child].name]
              f.print "  (#{(qty.to_i * qty2.to_i).to_s}) [X #{qty2}]  #{child}" # {@count[1][child]}
              f.print "  ##[S/L: #{s_l}]" unless s_l == nil
              f.puts
            }
            f.puts
          end
          #f.puts
        }
        f.puts
        f.puts
      }
    }
  end

end