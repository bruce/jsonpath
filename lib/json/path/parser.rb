module JSONPathGrammar
  include Treetop::Runtime

  def root
    @root || :path
  end

  module Path0
    def root
      elements[0]
    end

    def selectors
      elements[1]
    end
  end

  module Path1
    def to_proc
      lambda do |object|
        selectors.elements.inject([object]) do |reduce, selector|
          selector.descend(*reduce)
        end
      end
    end
  end

  def _nt_path
    start_index = index
    if node_cache[:path].has_key?(index)
      cached = node_cache[:path][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_root
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        r3 = _nt_child
        if r3
          s2 << r3
        else
          break
        end
      end
      if s2.empty?
        self.index = i2
        r2 = nil
      else
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      end
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Path0)
      r0.extend(Path1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:path][start_index] = r0

    return r0
  end

  def _nt_root
    start_index = index
    if node_cache[:root].has_key?(index)
      cached = node_cache[:root][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index('$', index) == index
      r0 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('$')
      r0 = nil
    end

    node_cache[:root][start_index] = r0

    return r0
  end

  def _nt_wildcard
    start_index = index
    if node_cache[:wildcard].has_key?(index)
      cached = node_cache[:wildcard][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index('*', index) == index
      r0 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('*')
      r0 = nil
    end

    node_cache[:wildcard][start_index] = r0

    return r0
  end

  module Subscript0
    def term
      elements[1]
    end

  end

  def _nt_subscript
    start_index = index
    if node_cache[:subscript].has_key?(index)
      cached = node_cache[:subscript][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('[', index) == index
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('[')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_term
      s0 << r2
      if r2
        if input.index(']', index) == index
          r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(']')
          r3 = nil
        end
        s0 << r3
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Subscript0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:subscript][start_index] = r0

    return r0
  end

  def _nt_term
    start_index = index
    if node_cache[:term].has_key?(index)
      cached = node_cache[:term][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index('x', index) == index
      r0 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('x')
      r0 = nil
    end

    node_cache[:term][start_index] = r0

    return r0
  end

  module Child0
    def word
      elements[1]
    end
  end

  module Child1
    def descend(*objects)
      objects.map do |obj|
        obj[word.text_value]
      end
    end
  end

  module Child2
  end

  module Child3
    def phrase
      elements[3]
    end

  end

  module Child4
    def descend(*objects)
      objects.map do |obj|
        obj[phrase.text_value]
      end
    end
  end

  module Child5
    def wildcard
      elements[1]
    end
  end

  module Child6
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

  def _nt_child
    start_index = index
    if node_cache[:child].has_key?(index)
      cached = node_cache[:child][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('.', index) == index
      r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('.')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_word
      s1 << r3
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Child0)
      r1.extend(Child1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i4, s4 = index, []
      if input.index('.', index) == index
        r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('.')
        r5 = nil
      end
      s4 << r5
      if r5
        if input.index('[', index) == index
          r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('[')
          r6 = nil
        end
        s4 << r6
        if r6
          if input.index('\'', index) == index
            r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('\'')
            r7 = nil
          end
          s4 << r7
          if r7
            s8, i8 = [], index
            loop do
              i9, s9 = index, []
              i10 = index
              if input.index('\'', index) == index
                r11 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('\'')
                r11 = nil
              end
              if r11
                r10 = nil
              else
                self.index = i10
                r10 = instantiate_node(SyntaxNode,input, index...index)
              end
              s9 << r10
              if r10
                if index < input_length
                  r12 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure("any character")
                  r12 = nil
                end
                s9 << r12
              end
              if s9.last
                r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
                r9.extend(Child2)
              else
                self.index = i9
                r9 = nil
              end
              if r9
                s8 << r9
              else
                break
              end
            end
            if s8.empty?
              self.index = i8
              r8 = nil
            else
              r8 = instantiate_node(SyntaxNode,input, i8...index, s8)
            end
            s4 << r8
            if r8
              if input.index('\'', index) == index
                r13 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('\'')
                r13 = nil
              end
              s4 << r13
              if r13
                if input.index(']', index) == index
                  r14 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(']')
                  r14 = nil
                end
                s4 << r14
              end
            end
          end
        end
      end
      if s4.last
        r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
        r4.extend(Child3)
        r4.extend(Child4)
      else
        self.index = i4
        r4 = nil
      end
      if r4
        r0 = r4
      else
        i15, s15 = index, []
        if input.index('.', index) == index
          r16 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('.')
          r16 = nil
        end
        s15 << r16
        if r16
          r17 = _nt_wildcard
          s15 << r17
        end
        if s15.last
          r15 = instantiate_node(SyntaxNode,input, i15...index, s15)
          r15.extend(Child5)
          r15.extend(Child6)
        else
          self.index = i15
          r15 = nil
        end
        if r15
          r0 = r15
        else
          self.index = i0
          r0 = nil
        end
      end
    end

    node_cache[:child][start_index] = r0

    return r0
  end

  def _nt_word
    start_index = index
    if node_cache[:word].has_key?(index)
      cached = node_cache[:word][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if input.index(Regexp.new('[a-zA-Z0-9]'), index) == index
        r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      self.index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
    end

    node_cache[:word][start_index] = r0

    return r0
  end

end

class JSONPathGrammarParser < Treetop::Runtime::CompiledParser
  include JSONPathGrammar
end
