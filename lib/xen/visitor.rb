require 'pp'

module XenConfigFile
  module AST
    module Visitor
      class PrettyPrintVisitor
        def visit_config_file(config_file)
          str = ''
          config_file.comments.each { |c| str << "##{c}\n" }
          config_file.vars.each { |v| str << v.accept(self) << "\n" }
          str
        end
      
        def visit_disk(disk)
          "\"#{disk.volume},#{disk.device},#{disk.mode}\""
        end
      
        def visit_assignment(assignment)
          # rhs = assignment.rhs.respond_to?(:accept) ? assignment.rhs.accept(self) : assignment.rhs
          "#{assignment.lhs} = #{visit(assignment.rhs)}"
        end
      
        def visit_array_assignment(array_assignment)
          if array_assignment.rhs.size > 1
            str = "#{array_assignment.lhs} = [ "
            buf = ''
            array_assignment.rhs.each do |val|
              buf << ' '*str.size << visit(val) << ",\n"
            end
            buf << ' '*str.size << ']'
            str << "\n" << buf
          else
            "#{array_assignment.lhs} = [ #{visit(array_assignment.rhs.first)} ]"
          end    
        end
      
        def visit_literal_string(literal_string)
          "\"#{literal_string}\""
        end
      
        def visit(obj)
          case obj.class.name.to_s
          when 'XenConfigFile::AST::ConfigFile'
            visit_config_file(obj)
          when 'XenConfigFile::AST::Assignment'
            visit_assignment(obj)
          when 'XenConfigFile::AST::ArrayAssignment'
            visit_array_assignment(obj)
          when 'XenConfigFile::AST::Disk'
            visit_disk(obj)
          when 'XenConfigFile::AST::LiteralString'
            visit_literal_string(obj)
          when 'Fixnum'
            obj
          else
            puts obj.class
          end
        end
      end
    end
  end
end
