require 'win32ole'

class XL_PLStarter

  def initialize (jobno, release_label, app)
    @shoes = app
    @jobno = jobno
    @release_label = release_label
    @xl = WIN32OLE.connect('Excel.Application')
    @job_directory = "#{$DIR}/data/Release_Count/#{jobno}/"
    create_dir(@job_directory)
    
    @save_dir = "#{$DIR}/data/Release_Count/#{jobno}/#{jobno}_#{release_label}_COUNT/"
    @template_file = "#{$DIR}/resources/ERO PIECE LIST MASTER.xlsx"

    create_dir(@save_dir)
    Dir.chdir(@save_dir) unless Dir.pwd == @save_dir
    @filename = "#{jobno} #{release_label} Piece List.xlsx"
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
    @ws = @wb.worksheets("SHEET LIST")
    @ws.range("B3").value = @jobno
    @ws.range("B4").value = @release_label
    @ws.range("B3").NumberFormat = "@"

    #HAVE TO CHANGE FORWARD SLASHES TO BACK SLASHES FOR WINDOW'S (EXCEL) SAKE
    dir_win = $DIR.gsub('/', '\\')
    save_filename = dir_win + "\\data\\Release_Count\\#{@jobno}\\#{@jobno}_#{@release_label}_COUNT\\#{@jobno} #{@release_label} Piece List.xlsx"
    Dir.chdir(@save_dir) unless Dir.pwd == @save_dir
    @wb.saveas(save_filename)
  end

end
