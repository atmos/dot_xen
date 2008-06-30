module XenConfigFile
  module AST
    module Visitor
      class PrettyPrintVisitor < Visitor
        
        visits XenConfigFile::AST::ConfigFile do |config_file, v|
          str = ''
          config_file.comments.each { |c| str << "##{c}\n" } unless config_file.comments.nil?
          config_file.vars.each { |var| str << var.accept(v) << "\n" }
          str
        end
  
        visits XenConfigFile::AST::Assignment do |assignment, v|
          "#{assignment.lhs} = #{assignment.rhs.accept(v)}"
        end

        visits XenConfigFile::AST::ArrayAssignment do |assignment, v|
          if assignment.rhs.nil?
            ""
          elsif assignment.rhs.size > 1
            str = "#{assignment.lhs} = [ "
            buf = ''
            assignment.rhs.each do |val|
              buf << ' '*str.size << val.accept(v) << ",\n"
            end
            buf << ' '*str.size << ']'
            str << "\n" << buf
          else
            "#{assignment.lhs} = [ #{assignment.rhs.first.accept(v)} ]"
          end
        end
  
        visits XenConfigFile::AST::Disk do |disk|
          "\"#{disk.volume},#{disk.device},#{disk.mode}\""
        end

        visits XenConfigFile::AST::LiteralString do |str|
          "\"#{str.value}\""
        end
  
        visits XenConfigFile::AST::LiteralNumber do |num|
          num.value.to_s
        end
      end
    end
  end
end