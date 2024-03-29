module ReleaseExcel

  def update_count(counter)
    @previous_time = @current_time
    load "#{@program_directory}/lib/release/report/update_count.rb"
    #uc = UpdateCount.new(self)
    counter.run @piece_list_name
  end

  def run_reports(counter)
    load "#{@program_directory}/lib/release/report/update_count.rb"
    load "#{@program_directory}/lib/release.rb"
    fn = "#{@data_directory}/#{@job_no}/#{@job_no}_#{@release}_COUNT/#{@job_no}-#{@release}.yml"
    rel = load_release r, @current_release.yml_file
    rel.setup @job_no, @release
    #uc = UpdateCount.new self
    counter.run_reports(rel)
  end

  def create_ero(creator)
    load "#{program_directory}/lib/release/excel/writer/xl_ero_creator.rb"
    # XL_EROStarter.new(@job_no, @release_label, @eng_ero_release_directory, @eng_ero_name, self)
    creator.create_ero
  end

  def create_bom(populator)
    load "#{program_directory}/lib/release/excel/populate_bom.rb"
    #Populate_Bom.new(@job_no, @release_label, @eng_ero_name, self)
    populator.run
  end

  def create_cut_pics(cut_creator)
    load "#{program_directory}/lib/release/excel/writer/insert_cuts.rb"
    # Insert_Cuts.new
    cut_creator.run
  end

  def create_tmr(populator)
    load "#{program_directory}/lib/release/excel/populate_tmr.rb"
    # Populate_TMR.new(@job_no, @release_label, @eng_ero_name, self)
    populator.run
  end

  def get_item_children(unit)
    p @unitlist

    string = "--#{unit}--\n"
    if @unitlist.has_key? unit
      @unitlist[unit].children.each_pair do |name, qty|
        string << "#{name}:  #{qty} \n"
      end
    else string = "Wrong Name"
    end
  end


  ##--METHODS



  

end