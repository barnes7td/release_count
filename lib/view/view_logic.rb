require 'yaml'

module ViewLogic

  @state = :base

  ##--EVENTS

  def open_current_reports
    if @current_report
      Thread.new do
        `start notepad.exe #{get_report}`
      end
    else 
      report "No current report"
    end
  end

  def show_report(report_name)
    dir = get_report report_name
    if File.exist?(dir)
      report File.read(dir)
      @current_report = report_name
    else
      report "Report does not exist"
      @current_report = false
    end
  end

  def show_item_report
    report @main_app.get_item_children @item_report.text
  end

  def update_based_on_state
    case @state
    when :setup_release_1
      @data = []
      @data << @enter_box.text
      prompt "Which Release?"
      @enter_box.text = ""
      @state = :setup_release_2
      @state_status.text = @state.to_s
    when :setup_release_2
      @data << @enter_box.text.upcase
      # setup_release
      if @main_app.release_exists?
        @main_app.set_release_info @data
        @main_app.setup
        display_job_info @data[0], @data[1]
        prompt ""
        @state = :base
      else
        change_release
      end
      @state_status.text = @state.to_s
      @enter_box.text = ""
    when :start_release_1
      @data = []
      @data << @enter_box.text
      prompt "Which Release?"
      @enter_box.text = ""
      @state = :start_release_2
      @state_status.text = @state.to_s
    when :start_release_2
      @data << @enter_box.text.upcase
      @main_app.set_release_info @data
      @main_app.setup
      start
      # setup_release
      XL_PLStarter.new(@job_no, @release, SHOES)
      prompt ""
      @enter_box.text = ""
      @state = :base
      @state_status.text = @state.to_s
      hide_input
      @report_box.text = "Release '#{@job_no} #{@release}' was created."
      observe_piece_list
    end
  end

  def change_release
    show_input
    @state = :setup_release_1
    @state_status.text = @state.to_s
    @prompt.text = "What is the Job Number?"
  end

  # def load_release(release, filename)
  #   release = YAML.load(File.read(filename))
  #   @shoes.report "Release file was loaded"
  #   return release
  # end

  def load_release(job_no, release_label)
    @job_no           = job_no
    @release_label    = release_label
    #release = Release.new
    
    #@main_app.open_piece_list

    # @main_app.update_count

    new_release = Release.new self, @program_directory
    new_release = YAML.load(File.read @release_controller.yml_file )
    @main_app = new_release
    @main_app.setup
  end

  def create_release
    load "#{program_directory}/lib/release/excel/writer/xl_piece_list_creator.rb"
    show_input
    @state = :start_release_1
    @state_status.text = @state.to_s
    @prompt.text = "What is the Job Number?"
  end


  ##--METHODS


  def get_report(report = @current_report)
    "#{@main_app.release_directory}/#{get_report_filename(report)}"
  end

  def get_report_filename(report)
    case report
    when :sheet   then "Count_Sheets.txt"
    when :detail  then "Detail Breakdown.txt"
    when :post    then "Post Breakdown.txt"
    when :release then "Release_List.txt"
    when :ship    then "Ship_Loose_List.txt"
    when :tmr     then "TMR.txt"
    end
  end

  def current_modification_time
    @current_time = File.mtime @main_app.piece_list_file if @main_app.release_exists?
  end

  def previous_modification_time
    @previous_time
  end

  def observe_piece_list
    if @main_app.release_exists?
      @previous_time = current_modification_time

      every 1 do
        if @previous_time
          if current_modification_time > previous_modification_time
            update_model
          end
        end
      end
    end
  end

  def release_exists?
    @release_controller.exists?
  end

  def start
    hide_input
    #@main_app.get_last_release
    # @main_app.set_release_info(arr)
    # @main_app.setup
    
    if release_exists?
      @release_controller.create_release
      # load_release @main_app, @main_app.release_filename
      load_release @main_app.job_no, @main_app.release_label
      display_job_info @main_app.job_no, @main_app.release_label
      report "Changed Releases"
      observe_piece_list
    else
      report "Release does not exist"
      change_release
    end
  end

end