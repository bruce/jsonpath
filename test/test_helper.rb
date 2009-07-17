require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'jsonpath'

class Test::Unit::TestCase
  
  private
  
  def parser
    @parser ||= JSONPath::Parser.new
  end
  
  def parse(path)
    parser.parse(path)
  end
  
  def assert_parses(path)
    result = parse(path)
    assert result, parser.failure_reason
  end
  
  def assert_resolves(obj, path, result)
    assert_parses path
    assert_equal safe_sort(result), safe_sort(parse(path).walk(obj))
  end
  
  def safe_sort(objs)
    objs.sort_by do |obj|
      obj ? obj.to_s : 0.to_s
    end
  end
  
end
