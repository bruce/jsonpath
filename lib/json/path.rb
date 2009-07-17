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
  end
  
end
