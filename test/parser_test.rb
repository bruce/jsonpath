require File.dirname(__FILE__) << "/test_helper"

# The content below was taken from the tests for the JS and PHP
# reference implementations at http://code.google.com/p/jsonpath/ 
class ParserTest < Test::Unit::TestCase

  context 'Simple' do
    setup { @parser = JSON::Path::Parser.new }
    should "parse successfully" do
      assert_parses '$.a'
      assert_kind_of Proc, parse('$.a').to_proc
      assert_resolves({"a" => 1}, '$.a', [1])
    end
    should "parse subscript with quotes successfully" do
      path = "$.['a b']"
      assert_parses path
      assert_kind_of Proc, parse(path).to_proc
      assert_resolves({"a b" => 1}, path, [1])
    end
    should "parse simple chained selectors with one terminal" do
      path = "$.['a b'].c"
      assert_parses path
      assert_kind_of Proc, parse(path).to_proc
      assert_resolves({"a b" => {"c" => 1}}, path, [1])
    end
    should "parses bare wildcard on hash" do
      path = "$.*"
      assert_parses path
      assert_kind_of Proc, parse(path).to_proc
      assert_resolves({"a" => 1, "b" => 2}, path, [1, 2])
    end
    should "parses bare wildcard on array" do
      path = "$.*"
      assert_parses path
      assert_kind_of Proc, parse(path).to_proc
      assert_resolves([1, 2, 3], path, [1, 2, 3])
    end
    should "parses through bare wildcard on array" do
      path = "$.*.name"
      assert_parses path
      assert_kind_of Proc, parse(path).to_proc
      assert_resolves([{"name" => 1}, {"name" => 2}, {"name" => 3}], path, [1, 2, 3])
    end
    should "parses through bare wildcard on array with additional wildcard" do
      path = "$.*.names.*"
      assert_parses path
      assert_kind_of Proc, parse(path).to_proc
      assert_resolves([
        {"names" => %w(foo bar)},
        {"names" => %w(baz quux)},
        {"names" => %w(spam eggs)}
      ], path, %w(foo bar baz quux spam eggs))
    end
    
  end
  
  private
  
  def parse(path)
    @parser.parse(path)
  end
  
  def assert_parses(path)
    result = parse(path)
    assert result, @parser.inspect
  end
  
  def assert_resolves(obj, path, result)
    assert_equal result.sort, parse(path).to_proc.call(obj).sort
  end
    
end
