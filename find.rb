require 'Find'

Find.find(ENV["HOME"]) do |path|
  if path[-7..-1] == "Dropbox"
    puts path
  end
end