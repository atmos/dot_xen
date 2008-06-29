require 'pp'

module XenConfigFile
  module AST
    module Visitor
      module PrettyPrintVisitor
        
        # a module and a visit function for each class in the AST
        module ConfigFile
          def visit(visitor)
            str = ''
            comments.each { |c| str << "##{c}\n" }
            vars.each { |v| str << v.visit(visitor) << "\n" }
            str
          end
        end
        
        module Assignment
          def visit(visitor)
            "#{lhs} = #{rhs.visit(visitor)}"
          end
        end
        
        module Disk
          def visit(visitor)
            "\"#{volume},#{device},#{mode}\""
          end
        end
        
        module ArrayAssignment
          def visit(visitor)
            if rhs.size > 1
              str = "#{lhs} = [ "
              buf = ''
              rhs.each do |val|
                buf << ' '*str.size << val.visit(visitor) << ",\n"
              end
              buf << ' '*str.size << ']'
              str << "\n" << buf
            else
              "#{lhs} = [ #{rhs.first.visit(visitor)} ]"
            end    
          end
        end
        
        module LiteralString
          def visit(visitor)
            "\"#{self}\""
          end
        end
        
        module Fixnum
          def visit(visitor); to_s end
        end
        
        
        # the class you feed to the AST
        class Visitor
          def initialize
          end
          def setup
            ast_ns = Object.const_get('XenConfigFile').const_get('AST')
            visitor_ns = ast_ns.const_get('Visitor').const_get('PrettyPrintVisitor')
            %w(ConfigFile Assignment ArrayAssignment Disk LiteralString).each do |klass|
              ast_ns.const_get("#{klass}").send(:include, visitor_ns.const_get("#{klass}"))
            end
            Object.const_get('Fixnum').send(:include, visitor_ns.const_get("Fixnum"))
          end
          def visit(obj)
            obj.visit(self)
          end
        end
      end
    end
  end
end
