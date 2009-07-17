require 'rubygems'
require 'treetop'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'jsonpath/parser'
require 'jsonpath/nodes'

module JSONPath
  
  Parser = ::JSONPathGrammarParser
  class ParseError < ::SyntaxError; end
  
  def self.lookup(obj, path)
    parser = Parser.new
    if (result = parser.parse(path))
      result.walk(obj)
    else
      raise ParseError, parser.failure_reason
    end
  end
  
end