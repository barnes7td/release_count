module ViewLogic

  @state = :base

  ##--EVENTS

  def update_model
    @previous_time = @current_time
    load "#{$DIR}/programs/release_count/update_count.rb"
    uc = UpdateCount.new(self)
    uc.run @pl_file_short
  end

  def open_current_reports
    if @current_report
      Thread.new do
        `start notepad.exe #{get_directory}`
      end
    else 
      report "No current report"
    end
  end

  def run_reports
    load "#{$DIR}/programs/release_count/update_count.rb"
    load "#{$DIR}/programs/release_count/MODEL/release_class.rb"
    fn = "#{@job_base_dir}/#{@job_no}/#{@job_no}_#{@release}_COUNT/#{@job_no}-#{@release}.yml"
    r = Release.new(SHOES)
    rel = load_release r, fn
    rel.setup @job_no, @release
    uc = UpdateCount.new self
    uc.run_reports(rel)
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
      setup_release
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
    load "#{$DIR}/programs/set_release.rb"
    show_input
    @state = :setup_release_1
    @state_status.text = @state.to_s
    @prompt.text = "What is the Job Number?"
  end

  def create_release
    load "#{$DIR}/lib/xl_piece_list_creator.rb"
    show_input
    @state = :start_release_1
    @state_status.text = @state.to_s
    @prompt.text = "What is the Job Number?"
  end

  def create_ero
    load "#{$DIR}/lib/xl_ero_creator.rb"
    XL_EROStarter.new(@job_no, @release, @ero_directory, @ero_file_short, self)
  end

  def create_bom
    load "#{$DIR}/programs/release_count/populate_bom.rb"
    Populate_Bom.new(@job_no, @release, @ero_file_short, self)
  end

  def create_cut_pics
    load "#{$DIR}/lib/welded/insert_cuts.rb"
    Insert_Cuts.new
  end

  def create_tmr
    load "#{$DIR}/programs/release_count/populate_tmr.rb"
    Populate_TMR.new(@job_no, @release, @ero_file_short, self)
  end

  def get_item_children
    load "#{$DIR}/programs/release_count/MODEL/release_class.rb"
    rel = Release.new SHOES
    rel.setup(@job_no, @release)
    rel = load_release(rel, rel.filename)

    @report_box.text = ""
    string = "--#{@item_report.text}--\n"
    if rel.unitlist.has_key? @item_report.text
      rel.unitlist[@item_report.text].children.each_pair do |name, qty|
        string << "#{name}:  #{qty} \n"
      end
    else string = "Wrong Name"
    end
    report string
  end


  ##--METHODS

  def setup_release
    # @data = set_release(SHOES)
    @id = ID.new(SHOES)
    @id.data = @data
    @id.save
    @job_no = @data[0]
    @release = @data[1]
    display_job_info @job_no, @release
  end

  def setup_directories
    @dir_list = set_directories(@job_no, @release, @job_base_dir)
    @count_dir = @dir_list[0]
    @job_dir = @dir_list[1]
    @pl_file = @dir_list[2]
    @ero_file = @dir_list[3]
    @pl_file_short = @dir_list[4]
    @ero_file_short = @dir_list[5]
    @ero_directory = @dir_list[6]
  end

  def setup
    hide_input
    @id = ID.new(SHOES)
    @id.load_data
    @data = @id.data 
    @job_no = @data[0]
    @release = @data[1]
    display_job_info @job_no, @release
    setup_directories
  end


  def get_directory(report = @current_report)
    "#{@count_dir}#{get_report_filename(report)}"
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

  def load_release(release, filename)
    data = File.read(filename)
    release = YAML.load(data)
    report "Release file was loaded"
    return release
  end

  def open_piece_list
    load "#{$DIR}/programs/release_count/SETUP/xl_connector.rb"
    xl = Xl_Connector.new
    xl.open_workbook @pl_file
  end

  def current_modification_time
    @current_time = File.mtime @pl_file if File.exist? @pl_file
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

end