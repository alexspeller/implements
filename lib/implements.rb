module Implements
  class InterfaceNotFullyImplementedError < Exception; end
  module ClassMethods
    def implements?(*modules)
      modules.all? do |mod|
        interfaces.include? mod
      end
    end


    private

    def implements(*modules, &block)
      class_eval &block
      modules.each do |mod|
        raise InterfaceNotFullyImplementedError unless mod.interface_methods.all?{ |m| instance_methods.include?(m.to_s) }        
        include mod
        self.interfaces << mod
      end
    end
  end
  
  module InstanceMethods
    
  end
  
  def self.included(klass)    
    klass.class_eval do
      extend ClassMethods
      include InstanceMethods

      class_inheritable_accessor :interfaces
      self.interfaces = []
    end
  end
end

Object.send :include, Implements