module JSONPath
    
  module Nodes
    
    class RootNode < Treetop::Runtime::SyntaxNode
      def walk(object)
        selectors.elements.inject([object]) do |reduce, selector|
          selector.descend(*reduce)
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
          # Note: I really don't like this special case.  This happens
          # because when wildcarding regularly, the results are the *children*,
          # but when using a .. descendant selector, you want the main parent,
          # too.  According to the JSONPath docs, '$..*' means "All members of
          # [the] JSON structure."  Should this support Array, as well?
          if obj.is_a?(Hash) && traversing_descendants?
            results.push(obj) unless results.include?(obj)
          end
        end
        results
      end
    end
    
    class KeyNode < PathNode
      
      # supports finding the key from self or child elements
      def find_keys(node=self, results=[], checked=[])
        if node.respond_to?(:key)
          results << node.key.text_value
        end
        if node.elements && !node.elements.empty?
          node.elements.each do |element|
            find_keys(element, results)
          end
        end
        results
      end
            
      def descend(*objects)
        results = []
        keys = find_keys
        traverse(objects) do |obj|
          if obj.is_a?(Hash)
            keys.each do |key|
              if obj.key?(key)
                results << obj[key]
              end
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
            begin
              if execute(obj)
                results << obj
              end
            rescue
            end
          end
        end
        results
      end
    
    end
    
  end
  
end
