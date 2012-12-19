require '../MODEL/release_class'
require '../REPORTS/counter'
require 'yaml'
require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

class Test_Counter < Test::Unit::TestCase
  def setup
    filename = File.new('C:/Sync/PROJECTS/RUBY/Release_Count_Excel/RCE/lib/TEST/test_support_files/555-555-TEST.yml')
    rel = Release.new("555-555", "TEST")
    @rel = load_release(rel, filename)
    @counter = Counter.new(@rel)
  end

  def load_release(rel, filename)
    data = File.read(filename)
    rel = YAML.load(data)
    return rel
  end

  def test_ship_loose
    #Test Ship Loose Math
    number = 80
    count = @counter.count_parts
    test = count[2]["#17 TEK SCREWS X 1"]
    assert_equal(number, test)
  end

  def teardown

  end
end
