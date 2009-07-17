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
    
    class PathNode < Treetop::Runtime::SyntaxNode
      
      def traverse(obj, &block)
        if !respond_to?(:lower) || lower.text_value == '.'
          obj.each(&block)
        elsif lower.text_value == '..'
          recurse(obj, &block)
        end
      end
      
      def recurse(obj, &block)
        block.call(obj)
        children = case obj
        when Hash
          obj.values
        when Array
          obj
        else
          return
        end
        children.each do |child|
          recurse(child, &block)
        end
      end
      
    end
    
    class WildcardNode < PathNode
      def descend(*objects)
        results = []
        traverse(objects) do |obj|
          values = case obj
          when Hash
            obj.values
          when Array
            obj
          end
          results.push(*values)
        end
        results
      end
    end
    
    class KeyNode < PathNode
      def descend(*objects)
        results = []
        traverse(objects) do |obj|
          results << obj[key.text_value]
        end
        results
      end
    end
    
    class IndexNode < PathNode
      def descend(*objects)
        offset = Integer(index.text_value)
        results = []
        traverse(objects) do |obj|
          if obj.size > offset
            results << obj[offset]
          end
        end
        results
      end
    end
    
    class SliceNode < PathNode
            
      def descend(*objects)
        results = []
        traverse(objects) do |obj|
          (start_offset..stop_offset(obj)).step(step_size) do |n|
            if obj.size > n
              results << obj[n]
            end
          end
        end
        results
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
    
    class ExprNode < PathNode
            
      def descend(*objects)
        code = template_code.text_value.gsub('@', '(obj)').gsub('\\(obj)', '@')
        results = []
        traverse(objects) do |obj|
          res = eval(code, binding)
          results << obj[res]
        end
        results
      end
    
    end
    
    class FilterNode < PathNode
      
      class Error < ::ArgumentError; end
      
      def descend(*objects)
        code = template_code.text_value.gsub('@', '(obj)').gsub('\\(obj)', '@')
        results = []
        traverse(objects) do |set|
          unless set.is_a?(Array) || set.is_a?(Hash)
            raise Error, "Filters only work on arrays and hashes"
          end
          values = set.is_a?(Array) ? set : set.values
          values.each do |obj|
            if eval(code, binding)
              results << obj
            end
          end
        end
        results
      end
    
    end
    
  end
  
end
