require 'pp'

module XenConfigFile
  module AST
    module Visitor
      class PrettyPrintVisitor
        def visitConfigFile(config_file)
          str = ''
          config_file.comments.each { |c| str << "##{c}\n" }
          config_file.vars.each { |v| str << v.accept(self) << "\n" }
          str
        end

        def visitAssignment(assignment)
          "#{assignment.lhs} = #{assignment.rhs.accept(self)}"
        end

        def visitArrayAssignment(assignment)
          if assignment.rhs.size > 1
            str = "#{assignment.lhs} = [ "
            buf = ''
            assignment.rhs.each do |val|
              buf << ' '*str.size << val.accept(self) << ",\n"
            end
            buf << ' '*str.size << ']'
            str << "\n" << buf
          else
            "#{assignment.lhs} = [ #{assignment.rhs.first.accept(self)} ]"
          end
        end
        
        def visitDisk(disk)
          "\"#{disk.volume},#{disk.device},#{disk.mode}\""
        end
        
        def visitLiteralString(str)
          "\"#{str.value}\""
        end
        
        def visitLiteralNumber(num)
          num.value.to_s
        end
      end
    end
  end
end
