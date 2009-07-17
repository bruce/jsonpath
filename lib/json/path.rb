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
    
    class SliceNode < Treetop::Runtime::SyntaxNode
            
      def descend(*objects)
        objects.inject([]) do |results, obj|
          (start_offset..stop_offset(obj)).step(step_size) do |n|
            if obj.size > n
              results << obj[n]
            end
          end
          results
        end
      end
      
      def start_offset
        @start_offset ||= Integer(start.text_value)
      end
      
      def stop_offset(obj)
        @stop_offset ||= if respond_to?(:stop)
          Integer(stop.text_value)
        else
          obj.size
        end
      end
      
      def step_size
        @step_size ||= if respond_to?(:step)
          Integer(step.text_value)
        else
          1
        end
      end
      
    end
    
    class FilterNode < Treetop::Runtime::SyntaxNode
      
      def descend(*objects)
        code = template_code.text_value.gsub('@', 'obj')
        objects.select do |obj|
          eval(code, binding)
        end
      end
    
    end
    
  end
  
end
