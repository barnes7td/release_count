$DIR = Pathname.new("./release.rb").realpath.dirname.to_s

Shoes = Struct.new :name
SHOES = Shoes.new "Mock"