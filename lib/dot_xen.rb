require 'rubygems'
require 'treetop'

require File.dirname(__FILE__) + '/xen/ast'
Treetop.load File.dirname(__FILE__) + '/xen/grammar'
require File.dirname(__FILE__) + '/xen/grammar_node_classes'

module XenConfigFile
  class Parser < Treetop::Runtime::CompiledParser
    include XenConfigFile::Grammar
    
    def simple_parse(io)
      parsed = parse(io)
      parsed.eval({}) unless parsed.nil?
    end
  end
end

