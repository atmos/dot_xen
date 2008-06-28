module XenConfigFile
  module AST
    
    class ConfigFile
      attr_accessor :disks, :vars, :comments
      def initialize(contents)
        @vars = [ ]
        @comments = contents.delete(:comments)
        @disks = ArrayAssignment.new(:disk, Disk.build(contents))
        contents[:variables] << @disks
        
        contents[:variables].each do |var|
          @vars << var
        end
      end
      
      def [](key)
        @vars.detect { |v| v.lhs == key }.rhs
      end
      
      def []=(key, value)
        @vars << (value.kind_of?(Array) ? ArrayAssignment.new(key, value) : Assignment.new(key, value))
        value
      end
      
      def to_s
        str = ''
        @comments.each { |c| str << "##{c}\n" }
        @vars.each { |v| str << "#{v}\n" }
        str
      end
    end
    
    class Disk
      attr_accessor :volume, :device, :mode
      def self.build(contents)
        disks = contents[:variables].detect { |var| var.lhs == :disk }
        unless disks.nil?
          contents[:variables].delete(disks)
        
          disks.rhs.map do |disk|
            volume, device, mode = disk.split(/,/)
            new(volume, device, mode)
          end unless disks.rhs.nil?
        end
      end
      def initialize(volume, device, mode)
        @volume, @device, @mode = volume, device, mode
      end
      def to_s; "\"#{volume},#{device},#{mode}\"" end
    end
    
    class Assignment
      attr_accessor :lhs, :rhs
      def initialize(lhs, rhs)
        @lhs, @rhs = lhs, rhs
      end
      def to_s
        "#{lhs} = #{rhs.to_s}"
      end
    end
    
    class ArrayAssignment < Assignment
      def to_s
        if rhs.size > 1
          str = "#{lhs} = [ "
          buf = ''
          rhs.each do |val|
            buf << ' '*str.size << val.to_s << ",\n"
          end
          buf << ' '*str.size << ']'
          str << "\n" << buf
        else
          "#{lhs} = [ #{rhs.first.to_s} ]"
        end
      end
    end
    
    class LiteralString < String
      def to_s; "\"#{self}\"" end
    end

  end
end