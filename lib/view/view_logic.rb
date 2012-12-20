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
    dir = get_directory report_name
    if File.exist?(dir)
      report File.read(dir)
      @current_report = report_name
    else
      report "Report does not exist"
      @current_report = false
    end
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
      load
      prompt ""
      @enter_box.text = ""
      @state = :base
      @state_status.text = @state.to_s
      hide_input
      observe_piece_list
    when :start_release_1
      @data = []
      @data << @enter_box.text
      prompt "Which Release?"
      @enter_box.text = ""
      @state = :start_release_2
      @state_status.text = @state.to_s
    when :start_release_2
      @data << @enter_box.text.upcase
      setup_release
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

  def load_release(release, filename)
    release = YAML.load(File.read(filename))
    @shoes.report "Release file was loaded"
    return release
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
    "#{@rel.ero_job_releasae_directory}/#{get_report_filename(report)}"
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

  def open_piece_list
    load "#{program_directory}/lib/release/excel/xl_connector.rb"
    xl = Xl_Connector.new
    xl.open_workbook @pl_file
  end

  def current_modification_time
    @current_time = File.mtime @main_app.piece_list_file if File.exist? @main_app.piece_list_file
  end

  def previous_modification_time
    @previous_time
  end

  def observe_piece_list
    @previous_time = current_modification_time

    every 1 do
      if @previous_time
        if current_modification_time > previous_modification_time
          update_model
        end
      end
    end
  end

  def start
    @main_app.get_last_release
    hide_input
    display_job_info @main_app.job_no, @main_app.release_label

    observe_piece_list
  end

end