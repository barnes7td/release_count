require 'win32ole'

class XL_EROStarter

  def initialize(jobno, release_label, directory, file, app)
    @shoes = app
    @jobno = jobno
    @release_label = release_label
    @xl = WIN32OLE.connect('Excel.Application')
    @save_directory = directory

    @template_file = "#{$DIR}/resources/ERO (TRS) - MASTER SEED FILE.xlsx"

    create_dir(@save_directory)
    @filename = "#{jobno} ERO #{release_label}.xlsx"
    create_file 
  end

  def create_dir(dir)
    unless File.exists?(dir)
      Dir.mkdir(dir)
      @shoes.report "Directory (#{dir}) was created"
    end
  end

  def create_file
    @wb = @xl.workbooks.open(@template_file)
    @ws = @wb.worksheets("Job Data (Fill In)")
    @ws.range("B6").value = @jobno
    @ws.range("B10").value = @release_label
    #@ws.range("B3").NumberFormat = "@"

    #HAVE TO CHANGE FORWARD SLASHES TO BACK SLASHES FOR EXCEL'S SAKE
    dir_win = @save_directory.gsub('/', '\\')
    save_filename = dir_win + "\\#{@filename}"
    Dir.chdir(@save_directory) unless Dir.pwd == @save_directory
    @wb.saveas(save_filename)
  end

end

