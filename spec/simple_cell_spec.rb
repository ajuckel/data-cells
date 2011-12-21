require File.expand_path(File.dirname(__FILE__) + '/../lib/data-cells.rb')

describe "a class using cells" do
  before(:all) do
    class ExampleClass
      include DataCells
      data_cells :foo, :bar
    end
  end
  context "an instance of a class using cells" do
    before(:each) do
      @ex = ExampleClass.new
    end
    it "should allow simple values to be assigned to cells" do
      @ex.foo = 5
      @ex.foo.should == 5
    end
    it "should allow blocks to be assigned to cells" do
      @ex.foo = lambda do
      end
    end
    it "should execute these blocks to provide values for the cell" do
      @ex.foo = lambda { 42 }
      @ex.foo.should == 42
    end
    it "should allow blocks to reference other cells" do
      @ex.foo = 5
      @ex.bar = lambda { |foo| foo * 2 }
      @ex.bar.should == 10
    end
    it "should not re-execute blocks if input cells have not changed" do
      @ex.foo = 5
      count = 0
      @ex.bar = lambda { |foo| count += 1; foo * 2 }
      @ex.bar.should == 10
      count.should == 1
      @ex.bar.should == 10
      count.should == 1
    end
    it "should update dependent values if their ancestor values have changed" do
      @ex.foo = 5
      @ex.bar = lambda { |foo| foo * 2 }
      @ex.bar.should == 10
      @ex.foo = 10
      @ex.bar.should == 20
    end
  end
end
