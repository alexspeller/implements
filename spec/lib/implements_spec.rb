require 'spec_helper'

describe Implements do
  before(:all) do
    module FirstInterface
      interface :price, :description
      
      def normally_included_method
        "normally_included_method"
      end
    end

    module SecondInterface
      interface :fooability
    end

    class FirstTest
      
      implements FirstInterface do
        def price
          100
        end
      
        def description
          "A FirstTest"
        end
      end
      
    end

    class SecondTest
      
      implements FirstInterface, SecondInterface do      
        def price
          100
        end

        def description
          "A FirstTest"
        end
      
        def fooability
          "Very fooable"
        end
      end

    end
    
    
  end
  
  before(:each) do
    @first_test = FirstTest.new
    @second_test = SecondTest.new
  end
  
  describe "Setup" do
    it "should raise if no block given" do
      lambda do
        class NoBlockClass
          implements FirstInterface
        end
      end.should raise_error
    end
    
    it "should implement the methods on the class" do
      FirstTest.instance_methods.should include("price")
      FirstTest.instance_methods.should include("description")
      
      SecondTest.instance_methods.should include("price")
      SecondTest.instance_methods.should include("description")
      SecondTest.instance_methods.should include("fooability")
    end
    
    it "should provide an implements? class method" do      
      FirstTest.interfaces.size.should == 1
      SecondTest.interfaces.size.should == 2
      
      FirstTest.implements?(FirstInterface).should be_true
      FirstTest.implements?(SecondInterface).should be_false
      FirstTest.implements?(FirstInterface, SecondInterface).should be_false
      FirstTest.implements?(SecondInterface, FirstInterface).should be_false

      SecondTest.implements?(FirstInterface).should be_true
      SecondTest.implements?(SecondInterface).should be_true
      SecondTest.implements?(FirstInterface, SecondInterface).should be_true
      SecondTest.implements?(SecondInterface, FirstInterface).should be_true      
    end
    
    it "should include instance methods " do
      @first_test.normally_included_method.should == "normally_included_method"
    end
    
    it "should store interface methods" do
      FirstInterface.interface_methods.should == [:price, :description]
      SecondInterface.interface_methods.should == [:fooability]
    end
  end
  
  describe "Checking of compliance" do
    it "should check compliance with no methods defined" do
      lambda do
        class BadClass1
          implements FirstInterface do
            
          end
        end
      end.should raise_error(Implements::InterfaceNotFullyImplementedError)

    end
    
    it "should check compliance with some methods defined" do
      lambda do
        class BadClass2
          implements FirstInterface do
            def description
              "A description"
            end
          end
        end
      end.should raise_error(Implements::InterfaceNotFullyImplementedError)
    end
    
    it "should check compliance with multiple interfaces" do
      lambda do
        class BadClass3
          implements FirstInterface, SecondInterface do
            def price
            end
            def description
              "A description"
            end
          end
        end
      end.should raise_error(Implements::InterfaceNotFullyImplementedError)
      
    end

    it "should check compliance with multiple interfaces the other way around" do
      lambda do
        class BadClass4
          implements FirstInterface, SecondInterface do          
            def fooability
            end
          end
        end
      end.should raise_error(Implements::InterfaceNotFullyImplementedError)
      
    end
    
  end
end