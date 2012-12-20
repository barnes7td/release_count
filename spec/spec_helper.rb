def program_directory
  Pathname.new("./release_count.rb").realpath.dirname.to_s
end
