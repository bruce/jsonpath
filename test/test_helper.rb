require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'jsonpath'

class Test::Unit::TestCase
  
  private
  
  def parser
    @parser ||= JSON::Path::Parser.new
  end
  
  def parse(path)
    parser.parse(path)
  end
  
  def assert_parses(path)
    result = parse(path)
    assert result, parser.inspect
  end
  
  def assert_resolves(obj, path, result)
    assert_parses path
    assert_equal result.sort, parse(path).to_proc.call(obj).sort
  end
  
end
