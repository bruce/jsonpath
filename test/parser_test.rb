require File.dirname(__FILE__) << "/test_helper"

# The content below was taken from the tests for the JS and PHP
# reference implementations at http://code.google.com/p/jsonpath/ 
class ParserTest < Test::Unit::TestCase

  context 'Traversing' do
    context "hash" do
      should "parse bareword child with single terminal" do
        path = '$.a'
        assert_resolves({"a" => 1}, path, [1])
      end
      should "parse subscripted quoted child with single terminal" do
        path = "$['a b']"
        assert_resolves({"a b" => 1}, path, [1])
      end
      should "parse subscripted quoted child and chained bareword" do
        path = "$['a b'].c"
        assert_resolves({"a b" => {"c" => 1}}, path, [1])
      end
      should "parses bare wildcard" do
        path = "$.*"
        assert_resolves({"a" => 1, "b" => 2}, path, [1, 2])
      end
      should "parse quoted wildcard on hash" do
        path = "$['*']"
        assert_resolves({"a" => 1, "b" => 2}, path, [1, 2])
      end
      should "parse quoted key outside of brackets" do
        path = "$.'a b'"
        assert_resolves({"a b" => 1}, path, [1])
      end
    end
    context "array" do
      should "parse bare wildcard" do
        path = "$.*"
        assert_resolves([1, 2, 3], path, [1, 2, 3])
      end
      should "parses subscripted quoted wildcard" do
        path = "$['*']"
        assert_resolves([1, 2, 3], path, [1, 2, 3])
      end
      should "parses through bare wildcard" do
        path = "$.*.name"
        assert_resolves([{"name" => 1}, {"name" => 2}, {"name" => 3}], path, [1, 2, 3])
      end
      should "parse index to single terminal" do
        path = "$[1]"
        assert_resolves(%w(foo bar baz), path, %w(bar))
      end
      should "parse index to multiple terminals" do
        path = "$.*[1].name"
        assert_resolves({
          "a" => [1, {"name" => 2}, 3],
          "b" => [4, {"name" => 5}, 6],
          "c" => [7, {"name" => 8}, 9],
        }, path, [2, 5, 8])
      end
    end
    context "combination wildcards" do
      should "parses through bare wildcard on array with additional wildcard" do
        path = "$.*.names.*"
        assert_resolves([
          {"names" => %w(foo bar)},
          {"names" => %w(baz quux)},
          {"names" => %w(spam eggs)}
        ], path, %w(foo bar baz quux spam eggs))
      end
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
            assert_resolves(@shallow, path, [3, 4, 5])
          end
          should "parse to multiple terminals" do
            path = '$[2:4].*.name'
            assert_resolves(@deep, path, %w(e1 f1 g1 h1 i1 j1))
          end
        end
        context "with explicit step" do
          should "parse to single terminal" do
            path = '$[2:4:2]'
            assert_resolves(@shallow, path, [3, 5])
          end
          should "parse to multiple terminals" do
            path = '$[2:4:2].*.name'
            assert_resolves(@deep, path, %w(e1 f1 i1 j1))
          end
        end
      end
      context "with explicit start and implict stop" do
        context "with implicit step" do
          should "parse to single terminal" do
            path = '$[2:]'
            assert_resolves(@shallow, path, [3, 4, 5, 6])
          end
          should "parse to multiple terminals" do
            path = '$[2:].*.name'
            assert_resolves(@deep, path, %w(e1 f1 g1 h1 i1 j1 k1 l1 m1 n1))
          end
        end
        context "with explicit step" do
           should "parse to single terminal" do
             path = '$[2::2]'
             assert_resolves(@shallow, path, [3, 5])
           end
           should "parse to multiple terminals" do
             path = '$[2::2].*.name'
             assert_resolves(@deep, path, %w(e1 f1 i1 j1 m1 n1))
           end
         end
      end
    end
    context "supporting filters in Ruby" do
      setup do
        @numbers = [1, 2, 3, 4, 5, 6, 7, 8]
        @hashes = [
          {"name" => 'Bruce', "age" => 29},
          {"name" => "Braedyn", "age" => 3},
          {"name" => "Jamis", "age" => 2},
        ]
      end
      context "when using self-contained single statements" do
        should "support simple object operations" do
          path = '$[?(@ % 2 == 0)]'
          assert_resolves(@numbers, path, [2, 4, 6, 8])
        end
        should "support manual object pathing" do
          path = %($[?(@['age'] % 2 == 0)].name)
          assert_resolves(@hashes, path, ["Jamis"])
        end
      end
      
    end
    context "descendants" do
      setup do
        @object = {
          "a" => [1, 2, [3, 4]],
          "b" => {
            "c" => 5,
            "e" => [6, 7]
          }
        }
      end
      should "be found with wildcard" do
        path = '$..*'
        assert_resolves(@object, path, [[1, 2, [3, 4]], 1, 2, [3, 4], 3, 4, {"c" => 5, "e" => [6, 7]}, 5, [6, 7], 6, 7, @object])
      end
      should "be found with deeper key" do
        path = '$..e'
        assert_resolves(@object, path, [[6, 7]])
      end
      should "be found with deeper index" do
        path = '$..[0]'
        assert_resolves(@object, path, [1, 3, 6])
      end
      should "resolve deeper chained selectors" do
        path = '$..e[?(@ % 2 == 0)]'
        assert_resolves(@object, path, [6])
      end
      
    end
    
  end
    
end
