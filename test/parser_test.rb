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
      path = "$['a b']"
      assert_parses path
      assert_kind_of Proc, parse(path).to_proc
      assert_resolves({"a b" => 1}, path, [1])
    end
    should "parse simple chained selectors with one terminal" do
      path = "$['a b'].c"
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
    should "parses quoted wildcard on hash" do
      path = "$['*']"
      assert_parses path
      assert_kind_of Proc, parse(path).to_proc
      assert_resolves({"a" => 1, "b" => 2}, path, [1, 2])
    end
    should "parses quoted wildcard on array" do
      path = "$['*']"
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
    should "parse quoted key outside of brackets" do
      path = "$.'a b'"
      assert_parses path
      assert_kind_of Proc, parse(path).to_proc
      assert_resolves({"a b" => 1}, path, [1])
    end
    should "parse index to single terminal" do
      path = "$[1]"
      assert_parses path
      assert_kind_of Proc, parse(path).to_proc
      assert_resolves(%w(foo bar baz), path, %w(bar))
    end
    should "parse index to multiple terminals" do
      path = "$.*[1].name"
      assert_parses path
      assert_kind_of Proc, parse(path).to_proc
      assert_resolves({
        "a" => [1, {"name" => 2}, 3],
        "b" => [4, {"name" => 5}, 6],
        "c" => [7, {"name" => 8}, 9],
      }, path, [2, 5, 8])
    end
    context "using slices" do
      setup {
        @deep = [
          {"a" => {"name" => "a1"}, "b" => {"name" => "b1"}},
          {"c" => {"name" => "c1"}, "d" => {"name" => "d1"}},
          {"e" => {"name" => "e1"}, "f" => {"name" => "f1"}},
          {"g" => {"name" => "g1"}, "h" => {"name" => "h1"}},
          {"i" => {"name" => "i1"}, "j" => {"name" => "j1"}},
          {"k" => {"name" => "k1"}, "l" => {"name" => "l1"}},
          {"m" => {"name" => "m1"}, "n" => {"name" => "n1"}},          
        ]
        @shallow = [1, 2, 3, 4, 5, 6]
      }
      context "with explicit start and stop" do
        context "with implicit step" do
          should "parse to single terminal" do
            path = '$[2:4]'
            assert_parses path
            assert_kind_of Proc, parse(path).to_proc
            assert_resolves(@shallow, path, [3, 4, 5])
          end
          should "parse to multiple terminals" do
            path = '$[2:4].*.name'
            assert_parses path
            assert_kind_of Proc, parse(path).to_proc
            assert_resolves(@deep, path, %w(e1 f1 g1 h1 i1 j1))
          end
        end
        context "with explicit step" do
          should "parse to single terminal" do
            path = '$[2:4:2]'
            assert_parses path
            assert_kind_of Proc, parse(path).to_proc
            assert_resolves(@shallow, path, [3, 5])
          end
          should "parse to multiple terminals" do
            path = '$[2:4:2].*.name'
            assert_parses path
            assert_kind_of Proc, parse(path).to_proc
            assert_resolves(@deep, path, %w(e1 f1 i1 j1))
          end
        end
      end
      context "with explicit start and implict stop" do
        context "with implicit step" do
          should "parse to single terminal" do
            path = '$[2:]'
            assert_parses path
            assert_kind_of Proc, parse(path).to_proc
            assert_resolves(@shallow, path, [3, 4, 5, 6])
          end
          should "parse to multiple terminals" do
            path = '$[2:].*.name'
            assert_parses path
            assert_kind_of Proc, parse(path).to_proc
            assert_resolves(@deep, path, %w(e1 f1 g1 h1 i1 j1 k1 l1 m1 n1))
          end
        end
        context "with explicit step" do
           should "parse to single terminal" do
             path = '$[2::2]'
             assert_parses path
             assert_kind_of Proc, parse(path).to_proc
             assert_resolves(@shallow, path, [3, 5])
           end
           should "parse to multiple terminals" do
             path = '$[2::2].*.name'
             assert_parses path
             assert_kind_of Proc, parse(path).to_proc
             assert_resolves(@deep, path, %w(e1 f1 i1 j1 m1 n1))
           end
         end
      end
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
