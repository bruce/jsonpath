require 'json'
require 'treetop'

$LOAD_PATH.unshift(File.dirname(__FILE__) << "/..")
require 'json/path/parser'

module JSON
    
  def self.path(obj_or_string, path)
    obj = obj_or_string.is_a?(String) ? JSON.parse(obj_or_string) : obj 
    []
  end
  
  module Path
    Parser = ::JSONPathGrammarParser
    
    class RootNode < Treetop::Runtime::SyntaxNode
      def to_proc
        lambda do |object|
          selectors.elements.inject([object]) do |reduce, selector|
            selector.descend(*reduce)
          end
        end
      end
    end
    
    class WildcardNode < Treetop::Runtime::SyntaxNode
      def descend(*objects)
        objects.inject([]) do |results, obj|
          values = case obj
          when Hash
            obj.values
          when Array
            obj
          end
          results.push(*values)
        end
      end
    end
    
    class KeyNode < Treetop::Runtime::SyntaxNode
      def descend(*objects)
        objects.map do |obj|
          obj[key.text_value]
        end
      end
    end
    
    class IndexNode < Treetop::Runtime::SyntaxNode
      def descend(*objects)
        offset = Integer(index.text_value)
        objects.inject([]) do |results, obj|
          if obj.size > offset
            results << obj[offset]
          end
          results
        end
      end
    end
    
  end
  
end
