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
    def template_code
      elements[1]
    end

  end

  module Child4
  end

  module Child5
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
        if input.index('.\'?(', index) == index
          r8 = instantiate_node(SyntaxNode,input, index...(index + 4))
          @index += 4
        else
          terminal_parse_failure('.\'?(')
          r8 = nil
        end
        s7 << r8
        if r8
          s9, i9 = [], index
          loop do
            i10, s10 = index, []
            i11 = index
            if input.index(')\'', index) == index
              r12 = instantiate_node(SyntaxNode,input, index...(index + 2))
              @index += 2
            else
              terminal_parse_failure(')\'')
              r12 = nil
            end
            if r12
              r11 = nil
            else
              self.index = i11
              r11 = instantiate_node(SyntaxNode,input, index...index)
            end
            s10 << r11
            if r11
              if index < input_length
                r13 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("any character")
                r13 = nil
              end
              s10 << r13
            end
            if s10.last
              r10 = instantiate_node(SyntaxNode,input, i10...index, s10)
              r10.extend(Child2)
            else
              self.index = i10
              r10 = nil
            end
            if r10
              s9 << r10
            else
              break
            end
          end
          if s9.empty?
            self.index = i9
            r9 = nil
          else
            r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
          end
          s7 << r9
          if r9
            if input.index(')\'', index) == index
              r14 = instantiate_node(SyntaxNode,input, index...(index + 2))
              @index += 2
            else
              terminal_parse_failure(')\'')
              r14 = nil
            end
            s7 << r14
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
            if input.index('\'', index) == index
              r17 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('\'')
              r17 = nil
            end
            s15 << r17
            if r17
              s18, i18 = [], index
              loop do
                i19, s19 = index, []
                i20 = index
                if input.index('\'', index) == index
                  r21 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('\'')
                  r21 = nil
                end
                if r21
                  r20 = nil
                else
                  self.index = i20
                  r20 = instantiate_node(SyntaxNode,input, index...index)
                end
                s19 << r20
                if r20
                  if index < input_length
                    r22 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure("any character")
                    r22 = nil
                  end
                  s19 << r22
                end
                if s19.last
                  r19 = instantiate_node(SyntaxNode,input, i19...index, s19)
                  r19.extend(Child4)
                else
                  self.index = i19
                  r19 = nil
                end
                if r19
                  s18 << r19
                else
                  break
                end
              end
              if s18.empty?
                self.index = i18
                r18 = nil
              else
                r18 = instantiate_node(SyntaxNode,input, i18...index, s18)
              end
              s15 << r18
              if r18
                if input.index('\'', index) == index
                  r23 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('\'')
                  r23 = nil
                end
                s15 << r23
              end
            end
          end
          if s15.last
            r15 = instantiate_node(JSON::Path::KeyNode,input, i15...index, s15)
            r15.extend(Child5)
          else
            self.index = i15
            r15 = nil
          end
          if r15
            r0 = r15
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
              r26 = _nt_wildcard
              s24 << r26
              if r26
                if input.index(']', index) == index
                  r27 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(']')
                  r27 = nil
                end
                s24 << r27
              end
            end
            if s24.last
              r24 = instantiate_node(JSON::Path::WildcardNode,input, i24...index, s24)
              r24.extend(Child6)
            else
              self.index = i24
              r24 = nil
            end
            if r24
              r0 = r24
            else
              i28, s28 = index, []
              if input.index('[', index) == index
                r29 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('[')
                r29 = nil
              end
              s28 << r29
              if r29
                r30 = _nt_number
                s28 << r30
                if r30
                  if input.index(']', index) == index
                    r31 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(']')
                    r31 = nil
                  end
                  s28 << r31
                end
              end
              if s28.last
                r28 = instantiate_node(JSON::Path::IndexNode,input, i28...index, s28)
                r28.extend(Child7)
              else
                self.index = i28
                r28 = nil
              end
              if r28
                r0 = r28
              else
                i32, s32 = index, []
                if input.index('[', index) == index
                  r33 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('[')
                  r33 = nil
                end
                s32 << r33
                if r33
                  r34 = _nt_number
                  s32 << r34
                  if r34
                    if input.index(':', index) == index
                      r35 = instantiate_node(SyntaxNode,input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure(':')
                      r35 = nil
                    end
                    s32 << r35
                    if r35
                      r36 = _nt_number
                      s32 << r36
                      if r36
                        if input.index(']', index) == index
                          r37 = instantiate_node(SyntaxNode,input, index...(index + 1))
                          @index += 1
                        else
                          terminal_parse_failure(']')
                          r37 = nil
                        end
                        s32 << r37
                      end
                    end
                  end
                end
                if s32.last
                  r32 = instantiate_node(JSON::Path::SliceNode,input, i32...index, s32)
                  r32.extend(Child8)
                else
                  self.index = i32
                  r32 = nil
                end
                if r32
                  r0 = r32
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
                      if input.index(':]', index) == index
                        r41 = instantiate_node(SyntaxNode,input, index...(index + 2))
                        @index += 2
                      else
                        terminal_parse_failure(':]')
                        r41 = nil
                      end
                      s38 << r41
                    end
                  end
                  if s38.last
                    r38 = instantiate_node(JSON::Path::SliceNode,input, i38...index, s38)
                    r38.extend(Child9)
                  else
                    self.index = i38
                    r38 = nil
                  end
                  if r38
                    r0 = r38
                  else
                    i42, s42 = index, []
                    if input.index('[', index) == index
                      r43 = instantiate_node(SyntaxNode,input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure('[')
                      r43 = nil
                    end
                    s42 << r43
                    if r43
                      r44 = _nt_number
                      s42 << r44
                      if r44
                        if input.index(':', index) == index
                          r45 = instantiate_node(SyntaxNode,input, index...(index + 1))
                          @index += 1
                        else
                          terminal_parse_failure(':')
                          r45 = nil
                        end
                        s42 << r45
                        if r45
                          r46 = _nt_number
                          s42 << r46
                          if r46
                            if input.index(':', index) == index
                              r47 = instantiate_node(SyntaxNode,input, index...(index + 1))
                              @index += 1
                            else
                              terminal_parse_failure(':')
                              r47 = nil
                            end
                            s42 << r47
                            if r47
                              r48 = _nt_number
                              s42 << r48
                              if r48
                                if input.index(']', index) == index
                                  r49 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                  @index += 1
                                else
                                  terminal_parse_failure(']')
                                  r49 = nil
                                end
                                s42 << r49
                              end
                            end
                          end
                        end
                      end
                    end
                    if s42.last
                      r42 = instantiate_node(JSON::Path::SliceNode,input, i42...index, s42)
                      r42.extend(Child10)
                    else
                      self.index = i42
                      r42 = nil
                    end
                    if r42
                      r0 = r42
                    else
                      i50, s50 = index, []
                      if input.index('[', index) == index
                        r51 = instantiate_node(SyntaxNode,input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure('[')
                        r51 = nil
                      end
                      s50 << r51
                      if r51
                        r52 = _nt_number
                        s50 << r52
                        if r52
                          if input.index('::', index) == index
                            r53 = instantiate_node(SyntaxNode,input, index...(index + 2))
                            @index += 2
                          else
                            terminal_parse_failure('::')
                            r53 = nil
                          end
                          s50 << r53
                          if r53
                            r54 = _nt_number
                            s50 << r54
                            if r54
                              if input.index(']', index) == index
                                r55 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                @index += 1
                              else
                                terminal_parse_failure(']')
                                r55 = nil
                              end
                              s50 << r55
                            end
                          end
                        end
                      end
                      if s50.last
                        r50 = instantiate_node(JSON::Path::SliceNode,input, i50...index, s50)
                        r50.extend(Child11)
                      else
                        self.index = i50
                        r50 = nil
                      end
                      if r50
                        r0 = r50
                      else
                        i56, s56 = index, []
                        if input.index('[?(', index) == index
                          r57 = instantiate_node(SyntaxNode,input, index...(index + 3))
                          @index += 3
                        else
                          terminal_parse_failure('[?(')
                          r57 = nil
                        end
                        s56 << r57
                        if r57
                          s58, i58 = [], index
                          loop do
                            i59, s59 = index, []
                            i60 = index
                            if input.index(')]', index) == index
                              r61 = instantiate_node(SyntaxNode,input, index...(index + 2))
                              @index += 2
                            else
                              terminal_parse_failure(')]')
                              r61 = nil
                            end
                            if r61
                              r60 = nil
                            else
                              self.index = i60
                              r60 = instantiate_node(SyntaxNode,input, index...index)
                            end
                            s59 << r60
                            if r60
                              if index < input_length
                                r62 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                @index += 1
                              else
                                terminal_parse_failure("any character")
                                r62 = nil
                              end
                              s59 << r62
                            end
                            if s59.last
                              r59 = instantiate_node(SyntaxNode,input, i59...index, s59)
                              r59.extend(Child12)
                            else
                              self.index = i59
                              r59 = nil
                            end
                            if r59
                              s58 << r59
                            else
                              break
                            end
                          end
                          if s58.empty?
                            self.index = i58
                            r58 = nil
                          else
                            r58 = instantiate_node(SyntaxNode,input, i58...index, s58)
                          end
                          s56 << r58
                          if r58
                            if input.index(')]', index) == index
                              r63 = instantiate_node(SyntaxNode,input, index...(index + 2))
                              @index += 2
                            else
                              terminal_parse_failure(')]')
                              r63 = nil
                            end
                            s56 << r63
                          end
                        end
                        if s56.last
                          r56 = instantiate_node(JSON::Path::FilterNode,input, i56...index, s56)
                          r56.extend(Child13)
                        else
                          self.index = i56
                          r56 = nil
                        end
                        if r56
                          r0 = r56
                        else
                          i64, s64 = index, []
                          if input.index('[', index) == index
                            r65 = instantiate_node(SyntaxNode,input, index...(index + 1))
                            @index += 1
                          else
                            terminal_parse_failure('[')
                            r65 = nil
                          end
                          s64 << r65
                          if r65
                            if input.index('\'', index) == index
                              r66 = instantiate_node(SyntaxNode,input, index...(index + 1))
                              @index += 1
                            else
                              terminal_parse_failure('\'')
                              r66 = nil
                            end
                            s64 << r66
                            if r66
                              s67, i67 = [], index
                              loop do
                                i68, s68 = index, []
                                i69 = index
                                if input.index('\'', index) == index
                                  r70 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                  @index += 1
                                else
                                  terminal_parse_failure('\'')
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
                              s64 << r67
                              if r67
                                if input.index('\'', index) == index
                                  r72 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                  @index += 1
                                else
                                  terminal_parse_failure('\'')
                                  r72 = nil
                                end
                                s64 << r72
                                if r72
                                  if input.index(']', index) == index
                                    r73 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                    @index += 1
                                  else
                                    terminal_parse_failure(']')
                                    r73 = nil
                                  end
                                  s64 << r73
                                end
                              end
                            end
                          end
                          if s64.last
                            r64 = instantiate_node(JSON::Path::KeyNode,input, i64...index, s64)
                            r64.extend(Child15)
                          else
                            self.index = i64
                            r64 = nil
                          end
                          if r64
                            r0 = r64
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
