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
    def start
      elements[1]
    end

    def stop
      elements[3]
    end

  end

  module Child9
    def start
      elements[1]
    end

  end

  module Child10
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

  module Child11
    def start
      elements[1]
    end

    def step
      elements[3]
    end

  end

  module Child12
  end

  module Child13
    def template_code
      elements[1]
    end

  end

  module Child14
  end

  module Child15
    def template_code
      elements[1]
    end

  end

  module Child16
  end

  module Child17
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
    r2 = _nt_lower
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
      r5 = _nt_lower
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
          r7 = instantiate_node(JSON::Path::FilterNode,input, i7...index, s7)
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
            r16 = instantiate_node(JSON::Path::KeyNode,input, i16...index, s16)
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
              r25 = instantiate_node(JSON::Path::WildcardNode,input, i25...index, s25)
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
                r29 = instantiate_node(JSON::Path::IndexNode,input, i29...index, s29)
                r29.extend(Child7)
              else
                self.index = i29
                r29 = nil
              end
              if r29
                r0 = r29
              else
                i33, s33 = index, []
                if input.index('[', index) == index
                  r34 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('[')
                  r34 = nil
                end
                s33 << r34
                if r34
                  r35 = _nt_number
                  s33 << r35
                  if r35
                    if input.index(':', index) == index
                      r36 = instantiate_node(SyntaxNode,input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure(':')
                      r36 = nil
                    end
                    s33 << r36
                    if r36
                      r37 = _nt_number
                      s33 << r37
                      if r37
                        if input.index(']', index) == index
                          r38 = instantiate_node(SyntaxNode,input, index...(index + 1))
                          @index += 1
                        else
                          terminal_parse_failure(']')
                          r38 = nil
                        end
                        s33 << r38
                      end
                    end
                  end
                end
                if s33.last
                  r33 = instantiate_node(JSON::Path::SliceNode,input, i33...index, s33)
                  r33.extend(Child8)
                else
                  self.index = i33
                  r33 = nil
                end
                if r33
                  r0 = r33
                else
                  i39, s39 = index, []
                  if input.index('[', index) == index
                    r40 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure('[')
                    r40 = nil
                  end
                  s39 << r40
                  if r40
                    r41 = _nt_number
                    s39 << r41
                    if r41
                      if input.index(':]', index) == index
                        r42 = instantiate_node(SyntaxNode,input, index...(index + 2))
                        @index += 2
                      else
                        terminal_parse_failure(':]')
                        r42 = nil
                      end
                      s39 << r42
                    end
                  end
                  if s39.last
                    r39 = instantiate_node(JSON::Path::SliceNode,input, i39...index, s39)
                    r39.extend(Child9)
                  else
                    self.index = i39
                    r39 = nil
                  end
                  if r39
                    r0 = r39
                  else
                    i43, s43 = index, []
                    if input.index('[', index) == index
                      r44 = instantiate_node(SyntaxNode,input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure('[')
                      r44 = nil
                    end
                    s43 << r44
                    if r44
                      r45 = _nt_number
                      s43 << r45
                      if r45
                        if input.index(':', index) == index
                          r46 = instantiate_node(SyntaxNode,input, index...(index + 1))
                          @index += 1
                        else
                          terminal_parse_failure(':')
                          r46 = nil
                        end
                        s43 << r46
                        if r46
                          r47 = _nt_number
                          s43 << r47
                          if r47
                            if input.index(':', index) == index
                              r48 = instantiate_node(SyntaxNode,input, index...(index + 1))
                              @index += 1
                            else
                              terminal_parse_failure(':')
                              r48 = nil
                            end
                            s43 << r48
                            if r48
                              r49 = _nt_number
                              s43 << r49
                              if r49
                                if input.index(']', index) == index
                                  r50 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                  @index += 1
                                else
                                  terminal_parse_failure(']')
                                  r50 = nil
                                end
                                s43 << r50
                              end
                            end
                          end
                        end
                      end
                    end
                    if s43.last
                      r43 = instantiate_node(JSON::Path::SliceNode,input, i43...index, s43)
                      r43.extend(Child10)
                    else
                      self.index = i43
                      r43 = nil
                    end
                    if r43
                      r0 = r43
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
                          if input.index('::', index) == index
                            r54 = instantiate_node(SyntaxNode,input, index...(index + 2))
                            @index += 2
                          else
                            terminal_parse_failure('::')
                            r54 = nil
                          end
                          s51 << r54
                          if r54
                            r55 = _nt_number
                            s51 << r55
                            if r55
                              if input.index(']', index) == index
                                r56 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                @index += 1
                              else
                                terminal_parse_failure(']')
                                r56 = nil
                              end
                              s51 << r56
                            end
                          end
                        end
                      end
                      if s51.last
                        r51 = instantiate_node(JSON::Path::SliceNode,input, i51...index, s51)
                        r51.extend(Child11)
                      else
                        self.index = i51
                        r51 = nil
                      end
                      if r51
                        r0 = r51
                      else
                        i57, s57 = index, []
                        if input.index('[(', index) == index
                          r58 = instantiate_node(SyntaxNode,input, index...(index + 2))
                          @index += 2
                        else
                          terminal_parse_failure('[(')
                          r58 = nil
                        end
                        s57 << r58
                        if r58
                          s59, i59 = [], index
                          loop do
                            i60, s60 = index, []
                            i61 = index
                            if input.index(')]', index) == index
                              r62 = instantiate_node(SyntaxNode,input, index...(index + 2))
                              @index += 2
                            else
                              terminal_parse_failure(')]')
                              r62 = nil
                            end
                            if r62
                              r61 = nil
                            else
                              self.index = i61
                              r61 = instantiate_node(SyntaxNode,input, index...index)
                            end
                            s60 << r61
                            if r61
                              if index < input_length
                                r63 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                @index += 1
                              else
                                terminal_parse_failure("any character")
                                r63 = nil
                              end
                              s60 << r63
                            end
                            if s60.last
                              r60 = instantiate_node(SyntaxNode,input, i60...index, s60)
                              r60.extend(Child12)
                            else
                              self.index = i60
                              r60 = nil
                            end
                            if r60
                              s59 << r60
                            else
                              break
                            end
                          end
                          if s59.empty?
                            self.index = i59
                            r59 = nil
                          else
                            r59 = instantiate_node(SyntaxNode,input, i59...index, s59)
                          end
                          s57 << r59
                          if r59
                            if input.index(')]', index) == index
                              r64 = instantiate_node(SyntaxNode,input, index...(index + 2))
                              @index += 2
                            else
                              terminal_parse_failure(')]')
                              r64 = nil
                            end
                            s57 << r64
                          end
                        end
                        if s57.last
                          r57 = instantiate_node(JSON::Path::ExprNode,input, i57...index, s57)
                          r57.extend(Child13)
                        else
                          self.index = i57
                          r57 = nil
                        end
                        if r57
                          r0 = r57
                        else
                          i65, s65 = index, []
                          if input.index('[?(', index) == index
                            r66 = instantiate_node(SyntaxNode,input, index...(index + 3))
                            @index += 3
                          else
                            terminal_parse_failure('[?(')
                            r66 = nil
                          end
                          s65 << r66
                          if r66
                            s67, i67 = [], index
                            loop do
                              i68, s68 = index, []
                              i69 = index
                              if input.index(')]', index) == index
                                r70 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                @index += 2
                              else
                                terminal_parse_failure(')]')
                                r70 = nil
                              end
                              if r70
                                r69 = nil
                              else
                                self.index = i69
                                r69 = instantiate_node(SyntaxNode,input, index...index)
                              end
                              s68 << r69
                              if r69
                                if index < input_length
                                  r71 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                  @index += 1
                                else
                                  terminal_parse_failure("any character")
                                  r71 = nil
                                end
                                s68 << r71
                              end
                              if s68.last
                                r68 = instantiate_node(SyntaxNode,input, i68...index, s68)
                                r68.extend(Child14)
                              else
                                self.index = i68
                                r68 = nil
                              end
                              if r68
                                s67 << r68
                              else
                                break
                              end
                            end
                            if s67.empty?
                              self.index = i67
                              r67 = nil
                            else
                              r67 = instantiate_node(SyntaxNode,input, i67...index, s67)
                            end
                            s65 << r67
                            if r67
                              if input.index(')]', index) == index
                                r72 = instantiate_node(SyntaxNode,input, index...(index + 2))
                                @index += 2
                              else
                                terminal_parse_failure(')]')
                                r72 = nil
                              end
                              s65 << r72
                            end
                          end
                          if s65.last
                            r65 = instantiate_node(JSON::Path::FilterNode,input, i65...index, s65)
                            r65.extend(Child15)
                          else
                            self.index = i65
                            r65 = nil
                          end
                          if r65
                            r0 = r65
                          else
                            i73, s73 = index, []
                            if input.index('[', index) == index
                              r74 = instantiate_node(SyntaxNode,input, index...(index + 1))
                              @index += 1
                            else
                              terminal_parse_failure('[')
                              r74 = nil
                            end
                            s73 << r74
                            if r74
                              if input.index('\'', index) == index
                                r75 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                @index += 1
                              else
                                terminal_parse_failure('\'')
                                r75 = nil
                              end
                              s73 << r75
                              if r75
                                s76, i76 = [], index
                                loop do
                                  i77, s77 = index, []
                                  i78 = index
                                  if input.index('\'', index) == index
                                    r79 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                    @index += 1
                                  else
                                    terminal_parse_failure('\'')
                                    r79 = nil
                                  end
                                  if r79
                                    r78 = nil
                                  else
                                    self.index = i78
                                    r78 = instantiate_node(SyntaxNode,input, index...index)
                                  end
                                  s77 << r78
                                  if r78
                                    if index < input_length
                                      r80 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                      @index += 1
                                    else
                                      terminal_parse_failure("any character")
                                      r80 = nil
                                    end
                                    s77 << r80
                                  end
                                  if s77.last
                                    r77 = instantiate_node(SyntaxNode,input, i77...index, s77)
                                    r77.extend(Child16)
                                  else
                                    self.index = i77
                                    r77 = nil
                                  end
                                  if r77
                                    s76 << r77
                                  else
                                    break
                                  end
                                end
                                if s76.empty?
                                  self.index = i76
                                  r76 = nil
                                else
                                  r76 = instantiate_node(SyntaxNode,input, i76...index, s76)
                                end
                                s73 << r76
                                if r76
                                  if input.index('\'', index) == index
                                    r81 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                    @index += 1
                                  else
                                    terminal_parse_failure('\'')
                                    r81 = nil
                                  end
                                  s73 << r81
                                  if r81
                                    if input.index(']', index) == index
                                      r82 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                      @index += 1
                                    else
                                      terminal_parse_failure(']')
                                      r82 = nil
                                    end
                                    s73 << r82
                                  end
                                end
                              end
                            end
                            if s73.last
                              r73 = instantiate_node(JSON::Path::KeyNode,input, i73...index, s73)
                              r73.extend(Child17)
                            else
                              self.index = i73
                              r73 = nil
                            end
                            if r73
                              r0 = r73
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
