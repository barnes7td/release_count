# To change this template, choose Tools | Templates
# and open the template in the editor.

class ConsolePrinter
  def initialize(data)
    @data = data
  end

  def print_data
    puts
    @data.each{|d|
      title = d[0]
      puts title.upcase + 'S:' unless d[1].empty?
      d[1].each{|a|
        puts a
      }
      puts
    }
  end
end
