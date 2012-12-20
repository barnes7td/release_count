require 'win32ole'

load "#{$DIR}/programs/release_count/REPORTS/reporter.rb"

class TMR_Creator

  def initialize(release, reporter, wb, ws)
    puts
    puts 'TMR CREATOR'
    #
    @release = release
    @reporter = reporter
    @type_cats = @release.type_cats
    @wb = wb
    @ws = ws
    @tmr = @reporter.tmr
    @start_row = 10
  end

  def seperate_pages
    @tmr_pages = []
    page = {}
    @tmr.each_pair do |u,q|
      page[u] = q
      if page.length == 26
        @tmr_pages << page
        page = {}
      end
    end
    if page.length != 26
      @tmr_pages << page
    end
    #puts @tmr_pages
    #puts
  end

  def add_bom_material
    #puts "add_bom_material from tmr_creator.rb is not coded yet"
    hash = {}
    @wb.worksheets.each do |ws|
      if ws.name.include? 'BOM'
        feet = ws.range("D5").value.to_i
        inches = ws.range("F5").value.to_i
        if feet > 0 || inches > 0
          feet += 1
          material = ws.range("C4").value
          alloy = ws.range("C5").value
          material = "#{material}, #{alloy}"
          if hash.has_key?(material)
            puts hash[material]
            puts
            hash[material] = feet + hash[material]
          else hash[material] = feet
          end
        end
      end
    end
    @tmr = hash.merge(@tmr)
  end

  def add_tmr_report
    #puts "add_tmr_report from tmr_creator.rb is not coded yet"
    add_bom_material
    seperate_pages
    cell = @ws.range("A#{@start_row}")
    @tmr_pages.each do |page|
      page.each_pair do |unit, qty|
        puts "#{unit}, #{qty}"
        if @release.unitlist[unit] != nil
          if @release.unitlist[unit].type == :stock
            stock = adjust_stock(unit, qty)
            desc_cell = cell.offset(0,1)
            desc_cell.value = stock
            cell = cell.offset(1,0)
          else
            cell.value = qty
            desc_cell = cell.offset(0,1)
            desc_cell.value = unit
            cell = cell.offset(1,0)
          end
        else
          cell.value = qty
          desc_cell = cell.offset(0,1)
          desc_cell.value = unit
          cell = cell.offset(1,0)
        end
      end
      cell = cell.offset(9,0)
    end
  end  

  def adjust_stock(unit, qty)
    p qty
    u = unit.dup
    index = u.rindex(/[Xx].*"/)
    p index
    text =  u.insert(index, "(#{qty} ") unless index == 0
    text =  text.insert(-1, ")")
  end


end


