require 'green_shoes'
require 'pathname'

require './lib/view/view_logic'
require './lib/view/view_api'
require './lib/application_controller'

Shoes.app :title => "Tuttle Release", :height => 800, :width => 700 do

  background gainsboro
    
  stack :margin => 10 do
    image "./images/TuttleLogo.png"

    flow do
                          para "Job No:",  :width => 100
      @job_no_display  =  para "-", :width => 100
                          para "Release:", :width => 100
      @release_display =  para "-", :width => 100
      @state_status    =  para @state.to_s, :width => 200
    end

    @prompt = para ""

    flow do
      @enter_box    = edit_line :width => 200
      @enter_button = button "Enter" do update_based_on_state end
    end

    flow do 
      button "Change Release"  do change_release end
      button "Open Piece List" do @controller.open_piece_list end
    end

    para "Create"
    
    flow do
      button "Create Release"   do @controller.create_release end
      button "Create ERO"       do @controller.create_ero end
      button "Create BOM's"     do @controller.create_bom end
      button "Create Cut Pics"  do @controller.create_cut_pics end
      button "Create TMR"       do @controller.create_tmr end
    end

    para "Report"

    flow do
      button "Update Count"         do @controller.update_count end
      button "Open Current Report"  do open_current_report end
      button "Run Reports"          do @controller.run_reports end
    end

    flow do
      button "Sheet Report"    do show_report(:sheet) end
      button "Detail Report"   do show_report(:detail) end
      button "Post Report"     do show_report(:post) end
      button "Release Report"  do show_report(:release) end
      button "Shipping Report" do show_report(:ship) end
      button "TMR Report"      do show_report(:tmr) end
      button "Item Report"     do show_item_report end
      @item_report = edit_line :width => 60
    end
    
    @report_box = edit_box :width => 580, :height => 350, :margin => 10
    
  end

  ###--- INITIALIZE ---###

  extend ViewLogic
  extend ViewAPI

  @program_directory  = Pathname.new(__FILE__).realpath.dirname.to_s
  @controller = ApplicationController.new self, @program_directory

  # start
  
end
