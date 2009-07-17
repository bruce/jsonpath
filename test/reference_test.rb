require File.dirname(__FILE__) << "/test_helper"
require 'json'

# The content below was taken from the tests for the JS and PHP
# reference implementations at http://code.google.com/p/jsonpath/ 
class ReferenceTest < Test::Unit::TestCase

  context 'Sample 1' do
    setup { @json = %({"a":"a","b":"b","c d":"e"}) }
    should 'resolve a simple path' do
      assert_resolves(object, "$.a", ["a"])
    end
    should 'resolve a path with quotes in brackets' do
      assert_resolves(object, "$['a']", ["a"])
    end
    should 'resolve a path with a space' do
      assert_resolves(object, "$.'c d'", ["e"])
    end
    should 'resolve a star' do
      assert_resolves(object, "$.*", ["a", "b", "e"])
    end
    should 'resolve a star with quotes in brackets' do
      assert_resolves(object, "$['*']", ["a", "b", "e"])
    end
    should 'resolve a star with quotes' do
      assert_resolves(object, "$[*]", ["a", "b", "e"])
    end
  end
  context 'Sample 2' do
    setup { @json = %([1, "2", 3.14, true, null]) }
    should 'resolve with a number in brackets' do
      assert_resolves(object, "$[0]", [1])
    end
    should 'resolve another number in brackets' do
      assert_resolves(object, "$[4]", [nil])
    end
    should 'resolve a star in brackets' do
      assert_resolves(object, "$[*]", [1, "2", 3.14, true, nil])
    end
    should 'resolve an end slice' do
      assert_resolves(object, "$[-1:]", [nil])
    end
  end
  context 'Sample 3' do
    setup { @json = %({"points":[{"id": "i1", "x": 4, "y": -5}, {"id": "i2", "x": -2, "y": 2, "z": 1}, {"id": "i3", "x": 8, "y": 3}, {"id": "i4", "x": -6, "y": -1}, {"id": "i5", "x": 0, "y": 2, "z": 1}, {"id": "i6", "x": 1, "y": 4}]}) }
    should 'resolve correctly' do
      assert_resolves(object, "$.points[1]", [{"id" => "i2", "x" => -2, "y" => 2, "z" => 1}])
    end
    should 'resolve a chained path' do
      assert_resolves(object, "$.points[4].x", [0])
    end
    should 'resolve by attribute match' do
      assert_resolves(object, "$.points[?(@['id']=='i4')].x", [-6])
    end
    should 'resolve a chained path with a star in brackets' do
      assert_resolves(object, "$.points[*].x", [4, -2, 8, -6, 0, 1])
    end
    should 'resolve by attribute operation' do
      assert_resolves(object, "$['points'][?(@['x']*@['x']+@['y']*@['y'] > 50)].id", ["i3"])
    end
    should 'resolve by attribute existence' do
      assert_resolves(object, "$.points[?(@['z'])].id", ["i2", "i5"])
    end
    should 'resolve by length property operation' do
      assert_resolves(object, "$.points[(@.length-1)].id", ["i6"])
    end
  end
  context 'Sample 4' do
    setup { @json = %({"menu":{"header":"SVG Viewer","items":[{"id": "Open"}, {"id": "OpenNew", "label": "Open New"}, null, {"id": "ZoomIn", "label": "Zoom In"}, {"id": "ZoomOut", "label": "Zoom Out"}, {"id": "OriginalView", "label": "Original View"}, null, {"id": "Quality"}, {"id": "Pause"}, {"id": "Mute"}, null, {"id": "Find", "label": "Find..."}, {"id": "FindAgain", "label": "Find Again"}, {"id": "Copy"}, {"id": "CopyAgain", "label": "Copy Again"}, {"id": "CopySVG", "label": "Copy SVG"}, {"id": "ViewSVG", "label": "View SVG"}, {"id": "ViewSource", "label": "View Source"}, {"id": "SaveAs", "label": "Save As"}, null, {"id": "Help"}, {"id": "About", "label": "About Adobe CVG Viewer..."}]}}) }
    should 'resolve testing on attribute' do
      assert_resolves(object, "$.menu.items[?(@ && @['id'] && !@['label'])].id", ["Open", "Quality", "Pause", "Mute", "Copy", "Help"])
    end
    should 'resolve testing on attribute with regular expression' do
      assert_resolves(object, "$.menu.items[?(@ && @['label'] && @['label'] =~ /SVG/)].id", ["CopySVG", "ViewSVG"])
    end
    should 'resolve on negative' do
      # !nil == true in Ruby
      assert_resolves(object, "$.menu.items[?(!@)]", [nil, nil, nil, nil])
    end
    should 'resolve descendant with number in brackets' do
      assert_resolves(object, "$..[0]", [{"id" => "Open"}])
    end
  end
  context 'Sample 5' do
    setup { @json = %({"a":[1, 2, 3, 4],"b":[5, 6, 7, 8]}) }
    should 'resolve descendant with number in brackets' do
      assert_resolves(object, "$..[0]", [1, 5])
    end
    should 'resolve descendant last items' do
      assert_resolves(object, "$..[-1:]", [4, 8])
    end
    should 'resolve by descendant value' do
      assert_resolves(object, "$..[?(@.is_a?(Numeric) && @ % 2 == 0)]", [2, 4, 6, 8])
    end
  end
  context 'Sample 6' do
    setup { @json = %({"lin":{"color":"red","x":2,"y":3},"cir":{"color":"blue","x":5,"y":2,"r":1},"arc":{"color":"green","x":2,"y":4,"r":2,"phi0":30,"dphi":120},"pnt":{"x":0,"y":7}}) }
    should 'resolve by operation in quotes' do
      assert_resolves(object, "$.'?(@['color'])'.x", [2, 5, 2])
    end
    should 'resolve by multiple quoted values in brackets' do
      assert_resolves(object, "$['lin','cir'].color", ["red", "blue"])
    end
  end
  context 'Sample 7' do
    setup { @json = %({"text":["hello", "world2.0"]}) }
    should 'resolve correctly filter 1' do
      assert_resolves(object, "$.text[?(@.length > 5)]", ["world2.0"])
    end
    should 'resolve correctly filter 2' do
      assert_resolves(object, "$.text[?(@[0, 1] == 'h')]", ["hello"])
    end
  end
  context 'Sample 8' do
    setup { @json = %({"a":{"a":2,"b":3},"b":{"a":4,"b":5},"c":{"a":{"a":6,"b":7},"c":8}}) }
    should 'resolve descendant' do
      assert_resolves(object, "$..a", [{"a" => 2, "b" => 3}, 2, 4, {"a" => 6, "b" => 7}, 6])
    end
  end
  context 'Sample 10' do
    setup { @json = %({"a":[{"a": 5, "@": 2, "$": 3}, {"a": 6, "@": 3, "$": 4}, {"a": 7, "@": 4, "$": 5}]}) }
    should 'resolve with quoted operation and escaped special character' do
      assert_resolves(object, "$.a[?(@['\\@']==3)]", [{"a" => 6, "@" => 3, "$" => 4}])
    end
    should 'resolve with quotes and brackets in operation' do
      assert_resolves(object, "$.a[?(@['$']==5)]", [{"a" => 7, "@" => 4, "$" => 5}])
    end
  end
    
  private
  
  def object
    JSON.parse(@json)
  end
    
end
