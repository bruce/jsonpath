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
      
      def traversing_descendants?
        respond_to?(:lower) && lower.text_value == '..'
      end
      
      def traverse(obj, &block)
        if !respond_to?(:lower) || lower.text_value == '.'
          obj.each(&block)
        elsif lower.text_value == '..'
          obj.each do |o|
            recurse(o, &block)
          end
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
          else
            next
          end
          results.push(*values)
          if obj.is_a?(Hash) && traversing_descendants?
            results.push(obj) unless results.include?(obj)
          end
        end
        results
      end
    end
    
    class KeyNode < PathNode
      def descend(*objects)
        results = []
        value = key.text_value
        traverse(objects) do |obj|
          if obj.is_a?(Hash)
            if obj.key?(value)
              results << obj[value]
            end
          end
        end
        results
      end
    end
    
    class IndexNode < PathNode
      def descend(*objects)
        offset = Integer(index.text_value)
        results = []
        traverse(objects) do |obj|
          if obj.is_a?(Array)
            if obj.size > offset
              results << obj[offset]
            end
          end
        end
        results
      end
    end
    
    class SliceNode < PathNode
            
      def descend(*objects)
        results = []
        traverse(objects) do |obj|
          if obj.is_a?(Array)
            values = obj[start_offset..stop_offset(obj)]
            0.step(values.size - 1, step_size) do |n|
              results << values[n]
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
    
    class CodeNode < PathNode
      
      def code
        @code ||= begin
          text = template_code.text_value
          text.gsub('@', '(obj)').gsub('\\(obj)', '@')
        end
      end
      
      def execute(obj)
        eval(code, binding)
      end
      
    end
    
    class ExprNode < CodeNode
            
      def descend(*objects)
        results = []
        traverse(objects) do |obj|
          res = execute(obj)
          case obj
          when Hash
            next unless obj.key?(res)
          when Array
            next unless obj.size > res
          else
            next
          end
          results << obj[res]
        end
        results
      end
    
    end
    
    class FilterNode < CodeNode
      
      class Error < ::ArgumentError; end
      
      def descend(*objects)
        results = []
        traverse(objects) do |set|
          next unless set.is_a?(Array) || set.is_a?(Hash)
          values = set.is_a?(Array) ? set : set.values
          values.each do |obj|
            if execute(obj)
              results << obj
            end
          end
        end
        results
      end
    
    end
    
  end
  
end
