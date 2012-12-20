require 'win32ole'



class BOM_Creator

  def initialize(rel, reporter, wb)
    puts
    puts 'BOM CREATOR'
    #
    @rel = rel

    load "#{@rel.program_directory}/lib/release/excel/xl_connector.rb"
    load "#{@rel.program_directory}/lib/release/report/reporter.rb"
    load "#{@rel.program_directory}/lib/release/excel/sorter_bom.rb"

    @reporter = reporter
    @type_cats = @release.type_cats
    @wb = wb
  end

  def add_tabs
    @wb.Activate

    puts
    puts "(M)echanical or (W)elded Job?"
    job_choice = gets.chomp.upcase
    @job_type = case job_choice
        when "M" then "Mech BOM"
        when "W" then "Welded BOM"
      end
    puts
    puts @job_type + " was chosen"

    #Get Tab Names from count through reporter
    tab_names = get_tab_names

    ws = @wb.Worksheets(@job_type)
    index = 0
    new_ws_name = @job_type + " (2)"

    tab_names.each {|t|
    ws.copy(ws)
    new_ws = @wb.Worksheets(new_ws_name)
    new_ws.name = tab_names[index].to_s.upcase + " BOM"
    bom_type = "(" + t.to_s.upcase + ")"
    new_ws.range('C3').value = bom_type
    index = index + 1
    }
  end

  def get_tab_names
    list = []
    types = @release.type_cats.bom
    @count = @reporter.count
    types.each{|t|
      @count[1].each_pair{|unit, qty|
        if @release.unitlist[unit].type == t
          list << t unless list.include? t
        end
      }
    }
    @types = list
    return list
  end

  def add_marks
    sorter = Sorter_bom.new(@reporter.bom, @types, @job_type)
    lists = sorter.sort_bom_data
    rev = sorter.sort_list_pages(lists)
    sorter.create_boms(rev, @wb)
  end


end


