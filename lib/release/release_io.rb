module ReleaseIO

  def get_last_release
    if release_exists?
      puts "true"
      read_last_release
    else
      puts "false"
    end
  end

  def release_exists?
    puts "#{@data_directory}/#{@job_no}/#{@job_no}_#{@release_label}_COUNT/#{@job_no}-#{@release_label}.yml"
    File.exists? "#{@data_directory}/#{@job_no}/#{@job_no}_#{@release_label}_COUNT/#{@job_no}-#{@release_label}.yml"
  end

  

  ####

  def save_release
    File.open(@release_filename, "w") do |f|
       YAML.dump(self, f)
    end
  end

  def open_piece_list
    load "#{program_directory}/lib/release/excel/xl_connector.rb"
    xl = Xl_Connector.new
    xl.open_workbook @piece_list_file
  end

  def run_reports
    load "#{@rel.program_directory}/lib/release/report/reporter.rb"
    rep = Reporter.new self
    rep.run rel
    rep.report_sheet_total_txt
    rep.report_bom_csv
    rep.report_detail_breakdown
    rep.report_post_breakdown
    rep.report_panel_breakdown
    rep.report_group_breakdown
    rep.report_release_list
    rep.report_ship_loose
    rep.report_tmr
    @shoes.report updated_time
  end


end