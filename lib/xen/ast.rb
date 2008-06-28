module XenConfigFile
  module AST
    module Visitor
      module InstanceMethods
        def accept(visitor)
          visitor.visit(self)
        end
      end
      def self.included(receiver)
        receiver.send :include, InstanceMethods
      end
    end
    
    class Base
      include Visitor
    end

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
      
      def [](key)
        @vars.detect { |v| v.lhs == key }.rhs
      end
      
      def []=(key, value)
        @vars << (value.kind_of?(Array) ? ArrayAssignment.new(key, value) : Assignment.new(key, value))
        value
      end
    end
    
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
    
    class Assignment < Base
      attr_accessor :lhs, :rhs
      def initialize(lhs, rhs)
        @lhs, @rhs = lhs, rhs
      end
    end
    
    class ArrayAssignment < Assignment; end
    
    # sucks that this inherits from string :\
    class LiteralString < String
      include Visitor
    end

  end
end