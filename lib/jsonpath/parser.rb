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
      r0 = instantiate_node(JSONPath::Nodes::RootNode,input, i0...index, s0)
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

  module Number0
  end

  def _nt_number
    start_index = index
    if node_cache[:number].has_key?(index)
      cached = node_cache[:number][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('-', index) == index
      r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('-')
      r2 = nil
    end
    if r2
      r1 = r2
    else
      r1 = instantiate_node(SyntaxNode,input, index...index)
    end
    s0 << r1
    if r1
      s3, i3 = [], index
      loop do
        if input.index(Regexp.new('[0-9]'), index) == index
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      if s3.empty?
        self.index = i3
        r3 = nil
      else
        r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
      end
      s0 << r3
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Number0)
    else
      self.index = i0
      r0 = nil
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

  def _nt_lower
    start_index = index
    if node_cache[:lower].has_key?(index)
      cached = node_cache[:lower][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_descendant
    if r1
      r0 = r1
    else
      if input.index('.', index) == index
        r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('.')
        r2 = nil
      end
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:lower][start_index] = r0

    return r0
  end

  def _nt_descendant
    start_index = index
    if node_cache[:descendant].has_key?(index)
      cached = node_cache[:descendant][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index('..', index) == index
      r0 = instantiate_node(SyntaxNode,input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('..')
      r0 = nil
    end

    node_cache[:descendant][start_index] = r0

    return r0
  end

  module WordList0
    def quoted_word
      elements[0]
    end

    def word_list
      elements[3]
    end
  end

  def _nt_word_list
    start_index = index
    if node_cache[:word_list].has_key?(index)
      cached = node_cache[:word_list][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_quoted_word
    s1 << r2
    if r2
      if input.index(',', index) == index
        r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure(',')
        r3 = nil
      end
      s1 << r3
      if r3
        s4, i4 = [], index
        loop do
          if input.index(' ', index) == index
            r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(' ')
            r5 = nil
          end
          if r5
            s4 << r5
          else
            break
          end
        end
        r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
        s1 << r4
        if r4
          r6 = _nt_word_list
          s1 << r6
        end
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(WordList0)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r7 = _nt_quoted_word
      if r7
        r0 = r7
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:word_list][start_index] = r0

    return r0
  end

  module QuotedWord0
  end

  module QuotedWord1
    def key
      elements[1]
    end

  end

  def _nt_quoted_word
    start_index = index
    if node_cache[:quoted_word].has_key?(index)
      cached = node_cache[:quoted_word][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('\'', index) == index
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('\'')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        i4 = index
        if input.index('\'', index) == index
          r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('\'')
          r5 = nil
        end
        if r5
          r4 = nil
        else
          self.index = i4
          r4 = instantiate_node(SyntaxNode,input, index...index)
        end
        s3 << r4
        if r4
          if index < input_length
            r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("any character")
            r6 = nil
          end
          s3 << r6
        end
        if s3.last
          r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
          r3.extend(QuotedWord0)
        else
          self.index = i3
          r3 = nil
        end
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
      if r2
        if input.index('\'', index) == index
          r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('\'')
          r7 = nil
        end
        s0 << r7
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(QuotedWord1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:quoted_word][start_index] = r0

    return r0
  end

  module Child0
    def lower
      elements[0]
    end

    def key
      elements[1]
    end
  end

  module Child1
    def lower
      elements[0]
    end

    def wildcard
      elements[1]
    end
  end

  module Child2
  end

  module Child3
    def lower
      elements[0]
    end

    def template_code
      elements[2]
    end

  end

  module Child4
  end

  module Child5
    def lower
      elements[0]
    end

    def key
      elements[2]
    end

  end

  module Child6
    def wildcard
      elements[1]
    end

  end

  module Child7
    def index
      elements[1]
    end

  end

  module Child8
    def lower
      elements[0]
    end

    def index
      elements[2]
    end

  end

  module Child9
    def start
      elements[1]
    end

    def stop
      elements[3]
    end

  end

  module Child10
    def lower
      elements[0]
    end

    def start
      elements[2]
    end

    def stop
      elements[4]
    end

  end

  module Child11
    def start
      elements[1]
    end

  end

  module Child12
    def lower
      elements[0]
    end

    def start
      elements[2]
    end

  end

  module Child13
    def start
      elements[1]
    end

    def stop
      elements[3]
    end

    def step
      elements[5]
    end

  end

  module Child14
    def lower
      elements[0]
    end

    def start
      elements[2]
    end

    def stop
      elements[4]
    end

    def step
      elements[6]
    end

  end

  module Child15
    def start
      elements[1]
    end

    def step
      elements[3]
    end

  end

  module Child16
    def lower
      elements[0]
    end

    def start
      elements[2]
    end

    def step
      elements[4]
    end

  end

  module Child17
  end

  module Child18
    def template_code
      elements[1]
    end

  end

  module Child19
  end

  module Child20
    def lower
      elements[0]
    end

    def template_code
      elements[2]
    end

  end

  module Child21
  end

  module Child22
    def template_code
      elements[1]
    end

  end

  module Child23
  end

  module Child24
    def lower
      elements[0]
    end

    def template_code
      elements[2]
    end

  end

  module Child25
    def word_list
      elements[1]
    end

  end

  module Child26
    def lower
      elements[0]
    end

    def word_list
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
    r2 = _nt_lower
    s1 << r2
    if r2
      r3 = _nt_bareword
      s1 << r3
    end
    if s1.last
      r1 = instantiate_node(JSONPath::Nodes::KeyNode,input, i1...index, s1)
      r1.extend(Child0)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i4, s4 = index, []
      r5 = _nt_lower
      s4 << r5
      if r5
        r6 = _nt_wildcard
        s4 << r6
      end
      if s4.last
        r4 = instantiate_node(JSONPath::Nodes::WildcardNode,input, i4...index, s4)
        r4.extend(Child1)
      else
        self.index = i4
        r4 = nil
      end
      if r4
        r0 = r4
      else
        i7, s7 = index, []
        r8 = _nt_lower
        s7 << r8
        if r8
          if input.index('\'?(', index) == index
            r9 = instantiate_node(SyntaxNode,input, index...(index + 3))
            @index += 3
          else
            terminal_parse_failure('\'?(')
            r9 = nil
          end
          s7 << r9
          if r9
            s10, i10 = [], index
            loop do
              i11, s11 = index, []
              i12 = index
              if input.index(')\'', index) == index
                r13 = instantiate_node(SyntaxNode,input, index...(index + 2))
                @index += 2
              else
                terminal_parse_failure(')\'')
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
              if input.index(')\'', index) == index
                r15 = instantiate_node(SyntaxNode,input, index...(index + 2))
                @index += 2
              else
                terminal_parse_failure(')\'')
                r15 = nil
              end
              s7 << r15
            end
          end
        end
        if s7.last
          r7 = instantiate_node(JSONPath::Nodes::FilterNode,input, i7...index, s7)
          r7.extend(Child3)
        else
          self.index = i7
          r7 = nil
        end
        if r7
          r0 = r7
        else
          i16, s16 = index, []
          r17 = _nt_lower
          s16 << r17
          if r17
            if input.index('\'', index) == index
              r18 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('\'')
              r18 = nil
            end
            s16 << r18
            if r18
              s19, i19 = [], index
              loop do
                i20, s20 = index, []
                i21 = index
                if input.index('\'', index) == index
                  r22 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('\'')
                  r22 = nil
                end
                if r22
                  r21 = nil
                else
                  self.index = i21
                  r21 = instantiate_node(SyntaxNode,input, index...index)
                end
                s20 << r21
                if r21
                  if index < input_length
                    r23 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure("any character")
                    r23 = nil
                  end
                  s20 << r23
                end
                if s20.last
                  r20 = instantiate_node(SyntaxNode,input, i20...index, s20)
                  r20.extend(Child4)
                else
                  self.index = i20
                  r20 = nil
                end
                if r20
                  s19 << r20
                else
                  break
                end
              end
              if s19.empty?
                self.index = i19
                r19 = nil
              else
                r19 = instantiate_node(SyntaxNode,input, i19...index, s19)
              end
              s16 << r19
              if r19
                if input.index('\'', index) == index
                  r24 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('\'')
                  r24 = nil
                end
                s16 << r24
              end
            end
          end
          if s16.last
            r16 = instantiate_node(JSONPath::Nodes::KeyNode,input, i16...index, s16)
            r16.extend(Child5)
          else
            self.index = i16
            r16 = nil
          end
          if r16
            r0 = r16
          else
            i25, s25 = index, []
            if input.index('[', index) == index
              r26 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('[')
              r26 = nil
            end
            s25 << r26
            if r26
              r27 = _nt_wildcard
              s25 << r27
              if r27
                if input.index(']', index) == index
                  r28 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(']')
                  r28 = nil
                end
                s25 << r28
              end
            end
            if s25.last
              r25 = instantiate_node(JSONPath::Nodes::WildcardNode,input, i25...index, s25)
              r25.extend(Child6)
            else
              self.index = i25
              r25 = nil
            end
            if r25
              r0 = r25
            else
              i29, s29 = index, []
              if input.index('[', index) == index
                r30 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('[')
                r30 = nil
              end
              s29 << r30
              if r30
                r31 = _nt_number
                s29 << r31
                if r31
                  if input.index(']', index) == index
                    r32 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(']')
                    r32 = nil
                  end
                  s29 << r32
                end
              end
              if s29.last
                r29 = instantiate_node(JSONPath::Nodes::IndexNode,input, i29...index, s29)
                r29.extend(Child7)
              else
                self.index = i29
                r29 = nil
              end
              if r29
                r0 = r29
              else
                i33, s33 = index, []
                r34 = _nt_lower
                s33 << r34
                if r34
                  if input.index('[', index) == index
                    r35 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure('[')
                    r35 = nil
                  end
                  s33 << r35
                  if r35
                    r36 = _nt_number
                    s33 << r36
                    if r36
                      if input.index(']', index) == index
                        r37 = instantiate_node(SyntaxNode,input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure(']')
                        r37 = nil
                      end
                      s33 << r37
                    end
                  end
                end
                if s33.last
                  r33 = instantiate_node(JSONPath::Nodes::IndexNode,input, i33...index, s33)
                  r33.extend(Child8)
                else
                  self.index = i33
                  r33 = nil
                end
                if r33
                  r0 = r33
                else
                  i38, s38 = index, []
                  if input.index('[', index) == index
                    r39 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure('[')
                    r39 = nil
                  end
                  s38 << r39
                  if r39
                    r40 = _nt_number
                    s38 << r40
                    if r40
                      if input.index(':', index) == index
                        r41 = instantiate_node(SyntaxNode,input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure(':')
                        r41 = nil
                      end
                      s38 << r41
                      if r41
                        r42 = _nt_number
                        s38 << r42
                        if r42
                          if input.index(']', index) == index
                            r43 = instantiate_node(SyntaxNode,input, index...(index + 1))
                            @index += 1
                          else
                            terminal_parse_failure(']')
                            r43 = nil
                          end
                          s38 << r43
                        end
                      end
                    end
                  end
                  if s38.last
                    r38 = instantiate_node(JSONPath::Nodes::SliceNode,input, i38...index, s38)
                    r38.extend(Child9)
                  else
                    self.index = i38
                    r38 = nil
                  end
                  if r38
                    r0 = r38
                  else
                    i44, s44 = index, []
                    r45 = _nt_lower
                    s44 << r45
                    if r45
                      if input.index('[', index) == index
                        r46 = instantiate_node(SyntaxNode,input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure('[')
                        r46 = nil
                      end
                      s44 << r46
                      if r46
                        r47 = _nt_number
                        s44 << r47
                        if r47
                          if input.index(':', index) == index
                            r48 = instantiate_node(SyntaxNode,input, index...(index + 1))
                            @index += 1
                          else
                            terminal_parse_failure(':')
                            r48 = nil
                          end
                          s44 << r48
                          if r48
                            r49 = _nt_number
                            s44 << r49
                            if r49
                              if input.index(']', index) == index
                                r50 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                @index += 1
                              else
                                terminal_parse_failure(']')
                                r50 = nil
                              end
                              s44 << r50
                            end
                          end
                        end
                      end
                    end
                    if s44.last
                      r44 = instantiate_node(JSONPath::Nodes::SliceNode,input, i44...index, s44)
                      r44.extend(Child10)
                    else
                      self.index = i44
                      r44 = nil
                    end
                    if r44
                      r0 = r44
                    else
                      i51, s51 = index, []
                      if input.index('[', index) == index
                        r52 = instantiate_node(SyntaxNode,input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure('[')
                        r52 = nil
                      end
                      s51 << r52
                      if r52
                        r53 = _nt_number
                        s51 << r53
                        if r53
                          if input.index(':]', index) == index
                            r54 = instantiate_node(SyntaxNode,input, index...(index + 2))
                            @index += 2
                          else
                            terminal_parse_failure(':]')
                            r54 = nil
                          end
                          s51 << r54
                        end
                      end
                      if s51.last
                        r51 = instantiate_node(JSONPath::Nodes::SliceNode,input, i51...index, s51)
                        r51.extend(Child11)
                      else
                        self.index = i51
                        r51 = nil
                      end
                      if r51
                        r0 = r51
                      else
                        i55, s55 = index, []
                        r56 = _nt_lower
                        s55 << r56
                        if r56
                          if input.index('[', index) == index
                            r57 = instantiate_node(SyntaxNode,input, index...(index + 1))
                            @index += 1
                          else
                            terminal_parse_failure('[')
                            r57 = nil
                          end
                          s55 << r57
                          if r57
                            r58 = _nt_number
                            s55 << r58
                            if r58
                              if input.index(':]', index) == index
                                r59 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                @index += 2
                              else
                                terminal_parse_failure(':]')
                                r59 = nil
                              end
                              s55 << r59
                            end
                          end
                        end
                        if s55.last
                          r55 = instantiate_node(JSONPath::Nodes::SliceNode,input, i55...index, s55)
                          r55.extend(Child12)
                        else
                          self.index = i55
                          r55 = nil
                        end
                        if r55
                          r0 = r55
                        else
                          i60, s60 = index, []
                          if input.index('[', index) == index
                            r61 = instantiate_node(SyntaxNode,input, index...(index + 1))
                            @index += 1
                          else
                            terminal_parse_failure('[')
                            r61 = nil
                          end
                          s60 << r61
                          if r61
                            r62 = _nt_number
                            s60 << r62
                            if r62
                              if input.index(':', index) == index
                                r63 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                @index += 1
                              else
                                terminal_parse_failure(':')
                                r63 = nil
                              end
                              s60 << r63
                              if r63
                                r64 = _nt_number
                                s60 << r64
                                if r64
                                  if input.index(':', index) == index
                                    r65 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                    @index += 1
                                  else
                                    terminal_parse_failure(':')
                                    r65 = nil
                                  end
                                  s60 << r65
                                  if r65
                                    r66 = _nt_number
                                    s60 << r66
                                    if r66
                                      if input.index(']', index) == index
                                        r67 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                        @index += 1
                                      else
                                        terminal_parse_failure(']')
                                        r67 = nil
                                      end
                                      s60 << r67
                                    end
                                  end
                                end
                              end
                            end
                          end
                          if s60.last
                            r60 = instantiate_node(JSONPath::Nodes::SliceNode,input, i60...index, s60)
                            r60.extend(Child13)
                          else
                            self.index = i60
                            r60 = nil
                          end
                          if r60
                            r0 = r60
                          else
                            i68, s68 = index, []
                            r69 = _nt_lower
                            s68 << r69
                            if r69
                              if input.index('[', index) == index
                                r70 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                @index += 1
                              else
                                terminal_parse_failure('[')
                                r70 = nil
                              end
                              s68 << r70
                              if r70
                                r71 = _nt_number
                                s68 << r71
                                if r71
                                  if input.index(':', index) == index
                                    r72 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                    @index += 1
                                  else
                                    terminal_parse_failure(':')
                                    r72 = nil
                                  end
                                  s68 << r72
                                  if r72
                                    r73 = _nt_number
                                    s68 << r73
                                    if r73
                                      if input.index(':', index) == index
                                        r74 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                        @index += 1
                                      else
                                        terminal_parse_failure(':')
                                        r74 = nil
                                      end
                                      s68 << r74
                                      if r74
                                        r75 = _nt_number
                                        s68 << r75
                                        if r75
                                          if input.index(']', index) == index
                                            r76 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                            @index += 1
                                          else
                                            terminal_parse_failure(']')
                                            r76 = nil
                                          end
                                          s68 << r76
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                            if s68.last
                              r68 = instantiate_node(JSONPath::Nodes::SliceNode,input, i68...index, s68)
                              r68.extend(Child14)
                            else
                              self.index = i68
                              r68 = nil
                            end
                            if r68
                              r0 = r68
                            else
                              i77, s77 = index, []
                              if input.index('[', index) == index
                                r78 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                @index += 1
                              else
                                terminal_parse_failure('[')
                                r78 = nil
                              end
                              s77 << r78
                              if r78
                                r79 = _nt_number
                                s77 << r79
                                if r79
                                  if input.index('::', index) == index
                                    r80 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                    @index += 2
                                  else
                                    terminal_parse_failure('::')
                                    r80 = nil
                                  end
                                  s77 << r80
                                  if r80
                                    r81 = _nt_number
                                    s77 << r81
                                    if r81
                                      if input.index(']', index) == index
                                        r82 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                        @index += 1
                                      else
                                        terminal_parse_failure(']')
                                        r82 = nil
                                      end
                                      s77 << r82
                                    end
                                  end
                                end
                              end
                              if s77.last
                                r77 = instantiate_node(JSONPath::Nodes::SliceNode,input, i77...index, s77)
                                r77.extend(Child15)
                              else
                                self.index = i77
                                r77 = nil
                              end
                              if r77
                                r0 = r77
                              else
                                i83, s83 = index, []
                                r84 = _nt_lower
                                s83 << r84
                                if r84
                                  if input.index('[', index) == index
                                    r85 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                    @index += 1
                                  else
                                    terminal_parse_failure('[')
                                    r85 = nil
                                  end
                                  s83 << r85
                                  if r85
                                    r86 = _nt_number
                                    s83 << r86
                                    if r86
                                      if input.index('::', index) == index
                                        r87 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                        @index += 2
                                      else
                                        terminal_parse_failure('::')
                                        r87 = nil
                                      end
                                      s83 << r87
                                      if r87
                                        r88 = _nt_number
                                        s83 << r88
                                        if r88
                                          if input.index(']', index) == index
                                            r89 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                            @index += 1
                                          else
                                            terminal_parse_failure(']')
                                            r89 = nil
                                          end
                                          s83 << r89
                                        end
                                      end
                                    end
                                  end
                                end
                                if s83.last
                                  r83 = instantiate_node(JSONPath::Nodes::SliceNode,input, i83...index, s83)
                                  r83.extend(Child16)
                                else
                                  self.index = i83
                                  r83 = nil
                                end
                                if r83
                                  r0 = r83
                                else
                                  i90, s90 = index, []
                                  if input.index('[(', index) == index
                                    r91 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                    @index += 2
                                  else
                                    terminal_parse_failure('[(')
                                    r91 = nil
                                  end
                                  s90 << r91
                                  if r91
                                    s92, i92 = [], index
                                    loop do
                                      i93, s93 = index, []
                                      i94 = index
                                      if input.index(')]', index) == index
                                        r95 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                        @index += 2
                                      else
                                        terminal_parse_failure(')]')
                                        r95 = nil
                                      end
                                      if r95
                                        r94 = nil
                                      else
                                        self.index = i94
                                        r94 = instantiate_node(SyntaxNode,input, index...index)
                                      end
                                      s93 << r94
                                      if r94
                                        if index < input_length
                                          r96 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                          @index += 1
                                        else
                                          terminal_parse_failure("any character")
                                          r96 = nil
                                        end
                                        s93 << r96
                                      end
                                      if s93.last
                                        r93 = instantiate_node(SyntaxNode,input, i93...index, s93)
                                        r93.extend(Child17)
                                      else
                                        self.index = i93
                                        r93 = nil
                                      end
                                      if r93
                                        s92 << r93
                                      else
                                        break
                                      end
                                    end
                                    if s92.empty?
                                      self.index = i92
                                      r92 = nil
                                    else
                                      r92 = instantiate_node(SyntaxNode,input, i92...index, s92)
                                    end
                                    s90 << r92
                                    if r92
                                      if input.index(')]', index) == index
                                        r97 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                        @index += 2
                                      else
                                        terminal_parse_failure(')]')
                                        r97 = nil
                                      end
                                      s90 << r97
                                    end
                                  end
                                  if s90.last
                                    r90 = instantiate_node(JSONPath::Nodes::ExprNode,input, i90...index, s90)
                                    r90.extend(Child18)
                                  else
                                    self.index = i90
                                    r90 = nil
                                  end
                                  if r90
                                    r0 = r90
                                  else
                                    i98, s98 = index, []
                                    r99 = _nt_lower
                                    s98 << r99
                                    if r99
                                      if input.index('[(', index) == index
                                        r100 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                        @index += 2
                                      else
                                        terminal_parse_failure('[(')
                                        r100 = nil
                                      end
                                      s98 << r100
                                      if r100
                                        s101, i101 = [], index
                                        loop do
                                          i102, s102 = index, []
                                          i103 = index
                                          if input.index(')]', index) == index
                                            r104 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                            @index += 2
                                          else
                                            terminal_parse_failure(')]')
                                            r104 = nil
                                          end
                                          if r104
                                            r103 = nil
                                          else
                                            self.index = i103
                                            r103 = instantiate_node(SyntaxNode,input, index...index)
                                          end
                                          s102 << r103
                                          if r103
                                            if index < input_length
                                              r105 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                              @index += 1
                                            else
                                              terminal_parse_failure("any character")
                                              r105 = nil
                                            end
                                            s102 << r105
                                          end
                                          if s102.last
                                            r102 = instantiate_node(SyntaxNode,input, i102...index, s102)
                                            r102.extend(Child19)
                                          else
                                            self.index = i102
                                            r102 = nil
                                          end
                                          if r102
                                            s101 << r102
                                          else
                                            break
                                          end
                                        end
                                        if s101.empty?
                                          self.index = i101
                                          r101 = nil
                                        else
                                          r101 = instantiate_node(SyntaxNode,input, i101...index, s101)
                                        end
                                        s98 << r101
                                        if r101
                                          if input.index(')]', index) == index
                                            r106 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                            @index += 2
                                          else
                                            terminal_parse_failure(')]')
                                            r106 = nil
                                          end
                                          s98 << r106
                                        end
                                      end
                                    end
                                    if s98.last
                                      r98 = instantiate_node(JSONPath::Nodes::ExprNode,input, i98...index, s98)
                                      r98.extend(Child20)
                                    else
                                      self.index = i98
                                      r98 = nil
                                    end
                                    if r98
                                      r0 = r98
                                    else
                                      i107, s107 = index, []
                                      if input.index('[?(', index) == index
                                        r108 = instantiate_node(SyntaxNode,input, index...(index + 3))
                                        @index += 3
                                      else
                                        terminal_parse_failure('[?(')
                                        r108 = nil
                                      end
                                      s107 << r108
                                      if r108
                                        s109, i109 = [], index
                                        loop do
                                          i110, s110 = index, []
                                          i111 = index
                                          if input.index(')]', index) == index
                                            r112 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                            @index += 2
                                          else
                                            terminal_parse_failure(')]')
                                            r112 = nil
                                          end
                                          if r112
                                            r111 = nil
                                          else
                                            self.index = i111
                                            r111 = instantiate_node(SyntaxNode,input, index...index)
                                          end
                                          s110 << r111
                                          if r111
                                            if index < input_length
                                              r113 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                              @index += 1
                                            else
                                              terminal_parse_failure("any character")
                                              r113 = nil
                                            end
                                            s110 << r113
                                          end
                                          if s110.last
                                            r110 = instantiate_node(SyntaxNode,input, i110...index, s110)
                                            r110.extend(Child21)
                                          else
                                            self.index = i110
                                            r110 = nil
                                          end
                                          if r110
                                            s109 << r110
                                          else
                                            break
                                          end
                                        end
                                        if s109.empty?
                                          self.index = i109
                                          r109 = nil
                                        else
                                          r109 = instantiate_node(SyntaxNode,input, i109...index, s109)
                                        end
                                        s107 << r109
                                        if r109
                                          if input.index(')]', index) == index
                                            r114 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                            @index += 2
                                          else
                                            terminal_parse_failure(')]')
                                            r114 = nil
                                          end
                                          s107 << r114
                                        end
                                      end
                                      if s107.last
                                        r107 = instantiate_node(JSONPath::Nodes::FilterNode,input, i107...index, s107)
                                        r107.extend(Child22)
                                      else
                                        self.index = i107
                                        r107 = nil
                                      end
                                      if r107
                                        r0 = r107
                                      else
                                        i115, s115 = index, []
                                        r116 = _nt_lower
                                        s115 << r116
                                        if r116
                                          if input.index('[?(', index) == index
                                            r117 = instantiate_node(SyntaxNode,input, index...(index + 3))
                                            @index += 3
                                          else
                                            terminal_parse_failure('[?(')
                                            r117 = nil
                                          end
                                          s115 << r117
                                          if r117
                                            s118, i118 = [], index
                                            loop do
                                              i119, s119 = index, []
                                              i120 = index
                                              if input.index(')]', index) == index
                                                r121 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                                @index += 2
                                              else
                                                terminal_parse_failure(')]')
                                                r121 = nil
                                              end
                                              if r121
                                                r120 = nil
                                              else
                                                self.index = i120
                                                r120 = instantiate_node(SyntaxNode,input, index...index)
                                              end
                                              s119 << r120
                                              if r120
                                                if index < input_length
                                                  r122 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                                  @index += 1
                                                else
                                                  terminal_parse_failure("any character")
                                                  r122 = nil
                                                end
                                                s119 << r122
                                              end
                                              if s119.last
                                                r119 = instantiate_node(SyntaxNode,input, i119...index, s119)
                                                r119.extend(Child23)
                                              else
                                                self.index = i119
                                                r119 = nil
                                              end
                                              if r119
                                                s118 << r119
                                              else
                                                break
                                              end
                                            end
                                            if s118.empty?
                                              self.index = i118
                                              r118 = nil
                                            else
                                              r118 = instantiate_node(SyntaxNode,input, i118...index, s118)
                                            end
                                            s115 << r118
                                            if r118
                                              if input.index(')]', index) == index
                                                r123 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                                @index += 2
                                              else
                                                terminal_parse_failure(')]')
                                                r123 = nil
                                              end
                                              s115 << r123
                                            end
                                          end
                                        end
                                        if s115.last
                                          r115 = instantiate_node(JSONPath::Nodes::FilterNode,input, i115...index, s115)
                                          r115.extend(Child24)
                                        else
                                          self.index = i115
                                          r115 = nil
                                        end
                                        if r115
                                          r0 = r115
                                        else
                                          i124, s124 = index, []
                                          if input.index('[', index) == index
                                            r125 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                            @index += 1
                                          else
                                            terminal_parse_failure('[')
                                            r125 = nil
                                          end
                                          s124 << r125
                                          if r125
                                            r126 = _nt_word_list
                                            s124 << r126
                                            if r126
                                              if input.index(']', index) == index
                                                r127 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                                @index += 1
                                              else
                                                terminal_parse_failure(']')
                                                r127 = nil
                                              end
                                              s124 << r127
                                            end
                                          end
                                          if s124.last
                                            r124 = instantiate_node(JSONPath::Nodes::KeyNode,input, i124...index, s124)
                                            r124.extend(Child25)
                                          else
                                            self.index = i124
                                            r124 = nil
                                          end
                                          if r124
                                            r0 = r124
                                          else
                                            i128, s128 = index, []
                                            r129 = _nt_lower
                                            s128 << r129
                                            if r129
                                              if input.index('[', index) == index
                                                r130 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                                @index += 1
                                              else
                                                terminal_parse_failure('[')
                                                r130 = nil
                                              end
                                              s128 << r130
                                              if r130
                                                r131 = _nt_word_list
                                                s128 << r131
                                                if r131
                                                  if input.index(']', index) == index
                                                    r132 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                                    @index += 1
                                                  else
                                                    terminal_parse_failure(']')
                                                    r132 = nil
                                                  end
                                                  s128 << r132
                                                end
                                              end
                                            end
                                            if s128.last
                                              r128 = instantiate_node(JSONPath::Nodes::KeyNode,input, i128...index, s128)
                                              r128.extend(Child26)
                                            else
                                              self.index = i128
                                              r128 = nil
                                            end
                                            if r128
                                              r0 = r128
                                            else
                                              self.index = i0
                                              r0 = nil
                                            end
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
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
