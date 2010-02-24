module Implements::Interface
  module ClassMethods
    def interface(*methods)
      self.interface_methods ||= []
      self.interface_methods += methods
    end
  end
  
  module InstanceMethods
    
  end
  
  def self.included(klass)    
    klass.class_eval do
      include InstanceMethods

      #Hmm, nested class_eval, meta meta meta...
      class_eval do
        attr_accessor :interface_methods
        self.interface_methods = []

        include ClassMethods
      end
      
    end
  end
end

Module.send :include, Implements::Interface