require 'pp'
module XenConfigFile
  module AST    
    # base class for hooking children nodes up
    class Base
      def self.inherited(subclass)
        subclass.send(:define_method, :accept) do |visitor|
          visitor.send("visit#{subclass.name.split(/::/).last}", self)
        end
      end
    end


    # what you get back from simple_parse
    class ConfigFile < Base
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
      
      # convenience to checkout a params value
      def [](key)
        @vars.detect { |v| v.lhs == key }.rhs
      end
      
      # set variables in existing ASTs with this
      def []=(key, value)
        @vars << (value.kind_of?(Array) ? ArrayAssignment.new(key, value) : Assignment.new(key, value))
        value
      end
    end
    
    # disks associated with the image
    class Disk < Base
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
    end
    
    # lhs is the param name, rhs is a literal string or literal number
    class Assignment < Base
      attr_accessor :lhs, :rhs
      def initialize(lhs, rhs)
        @lhs, @rhs = lhs, rhs
      end
    end
    
    # lhs is the param name, rhs is an array of literal strings or number
    class ArrayAssignment < Assignment
    end
    
    # internal representation of a string
    class LiteralString < Base
      attr_accessor :value
      def initialize(value)
        @value = value
      end
      def ==(value)
        if value.kind_of?LiteralString
          @value == value.value
        else
          @value == value
        end
      end
      def split(pattern)
        @value.split(pattern)
      end
    end
    
    # internal representation of a whole number
    class LiteralNumber < Base
      attr_accessor :value
      def initialize(value)
        @value = value
      end
      def ==(value)
        @value == value
      end
    end
  end
end