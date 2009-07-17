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
      r0 = instantiate_node(JSON::Path::RootNode,input, i0...index, s0)
      r0.extend(Path0)
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

  def _nt_number
    start_index = index
    if node_cache[:number].has_key?(index)
      cached = node_cache[:number][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if input.index(Regexp.new('[0-9]'), index) == index
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

    node_cache[:number][start_index] = r0

    return r0
  end

  module Wildcard0
  end

  def _nt_wildcard
    start_index = index
    if node_cache[:wildcard].has_key?(index)
      cached = node_cache[:wildcard][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index('*', index) == index
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('*')
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i2, s2 = index, []
      if input.index('\'', index) == index
        r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('\'')
        r3 = nil
      end
      s2 << r3
      if r3
        if input.index('*', index) == index
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('*')
          r4 = nil
        end
        s2 << r4
        if r4
          if input.index('\'', index) == index
            r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('\'')
            r5 = nil
          end
          s2 << r5
        end
      end
      if s2.last
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
        r2.extend(Wildcard0)
      else
        self.index = i2
        r2 = nil
      end
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
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
    def key
      elements[1]
    end
  end

  module Child1
    def wildcard
      elements[1]
    end
  end

  module Child2
  end

  module Child3
    def key
      elements[2]
    end

  end

  module Child4
    def wildcard
      elements[1]
    end

  end

  module Child5
    def index
      elements[1]
    end

  end

  module Child6
  end

  module Child7
    def key
      elements[2]
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
      r3 = _nt_bareword
      s1 << r3
    end
    if s1.last
      r1 = instantiate_node(JSON::Path::KeyNode,input, i1...index, s1)
      r1.extend(Child0)
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
        r6 = _nt_wildcard
        s4 << r6
      end
      if s4.last
        r4 = instantiate_node(JSON::Path::WildcardNode,input, i4...index, s4)
        r4.extend(Child1)
      else
        self.index = i4
        r4 = nil
      end
      if r4
        r0 = r4
      else
        i7, s7 = index, []
        if input.index('.', index) == index
          r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('.')
          r8 = nil
        end
        s7 << r8
        if r8
          if input.index('\'', index) == index
            r9 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('\'')
            r9 = nil
          end
          s7 << r9
          if r9
            s10, i10 = [], index
            loop do
              i11, s11 = index, []
              i12 = index
              if input.index('\'', index) == index
                r13 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('\'')
                r13 = nil
              end
              if r13
                r12 = nil
              else
                self.index = i12
                r12 = instantiate_node(SyntaxNode,input, index...index)
              end
              s11 << r12
              if r12
                if index < input_length
                  r14 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure("any character")
                  r14 = nil
                end
                s11 << r14
              end
              if s11.last
                r11 = instantiate_node(SyntaxNode,input, i11...index, s11)
                r11.extend(Child2)
              else
                self.index = i11
                r11 = nil
              end
              if r11
                s10 << r11
              else
                break
              end
            end
            if s10.empty?
              self.index = i10
              r10 = nil
            else
              r10 = instantiate_node(SyntaxNode,input, i10...index, s10)
            end
            s7 << r10
            if r10
              if input.index('\'', index) == index
                r15 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('\'')
                r15 = nil
              end
              s7 << r15
            end
          end
        end
        if s7.last
          r7 = instantiate_node(JSON::Path::KeyNode,input, i7...index, s7)
          r7.extend(Child3)
        else
          self.index = i7
          r7 = nil
        end
        if r7
          r0 = r7
        else
          i16, s16 = index, []
          if input.index('[', index) == index
            r17 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('[')
            r17 = nil
          end
          s16 << r17
          if r17
            r18 = _nt_wildcard
            s16 << r18
            if r18
              if input.index(']', index) == index
                r19 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(']')
                r19 = nil
              end
              s16 << r19
            end
          end
          if s16.last
            r16 = instantiate_node(JSON::Path::WildcardNode,input, i16...index, s16)
            r16.extend(Child4)
          else
            self.index = i16
            r16 = nil
          end
          if r16
            r0 = r16
          else
            i20, s20 = index, []
            if input.index('[', index) == index
              r21 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('[')
              r21 = nil
            end
            s20 << r21
            if r21
              r22 = _nt_number
              s20 << r22
              if r22
                if input.index(']', index) == index
                  r23 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(']')
                  r23 = nil
                end
                s20 << r23
              end
            end
            if s20.last
              r20 = instantiate_node(JSON::Path::IndexNode,input, i20...index, s20)
              r20.extend(Child5)
            else
              self.index = i20
              r20 = nil
            end
            if r20
              r0 = r20
            else
              i24, s24 = index, []
              if input.index('[', index) == index
                r25 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('[')
                r25 = nil
              end
              s24 << r25
              if r25
                if input.index('\'', index) == index
                  r26 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('\'')
                  r26 = nil
                end
                s24 << r26
                if r26
                  s27, i27 = [], index
                  loop do
                    i28, s28 = index, []
                    i29 = index
                    if input.index('\'', index) == index
                      r30 = instantiate_node(SyntaxNode,input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure('\'')
                      r30 = nil
                    end
                    if r30
                      r29 = nil
                    else
                      self.index = i29
                      r29 = instantiate_node(SyntaxNode,input, index...index)
                    end
                    s28 << r29
                    if r29
                      if index < input_length
                        r31 = instantiate_node(SyntaxNode,input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure("any character")
                        r31 = nil
                      end
                      s28 << r31
                    end
                    if s28.last
                      r28 = instantiate_node(SyntaxNode,input, i28...index, s28)
                      r28.extend(Child6)
                    else
                      self.index = i28
                      r28 = nil
                    end
                    if r28
                      s27 << r28
                    else
                      break
                    end
                  end
                  if s27.empty?
                    self.index = i27
                    r27 = nil
                  else
                    r27 = instantiate_node(SyntaxNode,input, i27...index, s27)
                  end
                  s24 << r27
                  if r27
                    if input.index('\'', index) == index
                      r32 = instantiate_node(SyntaxNode,input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure('\'')
                      r32 = nil
                    end
                    s24 << r32
                    if r32
                      if input.index(']', index) == index
                        r33 = instantiate_node(SyntaxNode,input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure(']')
                        r33 = nil
                      end
                      s24 << r33
                    end
                  end
                end
              end
              if s24.last
                r24 = instantiate_node(JSON::Path::KeyNode,input, i24...index, s24)
                r24.extend(Child7)
              else
                self.index = i24
                r24 = nil
              end
              if r24
                r0 = r24
              else
                self.index = i0
                r0 = nil
              end
            end
          end
        end
      end
    end

    node_cache[:child][start_index] = r0

    return r0
  end

  def _nt_bareword
    start_index = index
    if node_cache[:bareword].has_key?(index)
      cached = node_cache[:bareword][index]
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

    node_cache[:bareword][start_index] = r0

    return r0
  end

end

class JSONPathGrammarParser < Treetop::Runtime::CompiledParser
  include JSONPathGrammar
end
