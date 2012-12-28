require './lib/release/model/unit'

describe Unit do
  
  before do
    @unit = Unit.new("P-1", :post)
  end

  it "should initialize instance variables" do
    @unit.name.should eql "P-1"
    @unit.name == :post
    # @unit.children == []
  end

  it "should add children" do
    @unit.add_child("30-16", 2, 1)
    puts @unit.find_child("30-16")
    @unit.find_child("30-16") == "30-16"
  end

  # describe "#delete_child" do

  #   it "should delete children" do
  #     @unit.delete_child("30-16")
  #     @unit.children == {}
  #     @unit.ship_loose == {}
  #   end

  #   it "should not error out if child does not exist" do
  #     @unit.delete_child("30-18")
  #   end

  # end

end