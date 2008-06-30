require 'pp'

module XenConfigFile
  module AST
    module Visitor
      class Visitor
        def self.visits(klass, &block)
          visitors[klass.name] = block
        end
        
        def self.visitors
          @visitors ||= { }
        end
        
        def visit(node)
          block = self.class.visitors[node.class.name] or raise "no eval block defined for node #{node.class.intern}"
          block.arity == 1 ? block.call(node) : block.call(node, self)
        end
      end
    end
  end
end
