require "spec_helper"

describe Putter::ClassDebugger do
  before(:each) do
    @class = Class.new do
      def self.test_class_method
        puts "test_class_method"
      end

      def self.test_class_method_arg(arg)
        puts "test_class_method_arg: #{arg}"
      end

      def self.test_class_method_block(&blk)
        yield
      end

      def self.test_class_method_block_arg(&blk)
        yield "World"
      end
    end
  end

  describe "initialize" do
    it "sends methods to the wrapped object" do
      debugger = Putter::ClassDebugger.new(@class)

      expect(@class).to receive(:test_class_method)

      debugger.test_class_method
    end

    it "sends arguments to the wrapped object" do
      debugger = Putter::ClassDebugger.new(@class)

      expect(@class).to receive(:test_class_method_arg).with("Hello")

      debugger.test_class_method_arg("Hello")
    end

    it "sends blocks to the wrapped object" do
      debugger = Putter::ClassDebugger.new(@class)

      expect(@class).to receive(:test_class_method_block).and_call_original

      str = ""
      debugger.test_class_method_block do
        str = "Success"
      end
      expect(str).to eq("Success")
    end

    it "sends arguments and blocks to the wrapped object" do
      debugger = Putter::ClassDebugger.new(@class)

      expect(@class).to receive(:test_class_method_block_arg).and_call_original

      str = "Hello "
      debugger.test_class_method_block_arg do |subj|
        str += "#{subj}"
      end

      expect(str).to eq("Hello World")
    end

    it "prepends the proxy only once" do
      debugger = Putter::ClassDebugger.new(@class)
      allow(@class).to receive(:method_1)
      allow(@class).to receive(:method_2)

      debugger.method_1
      debugger.method_2("method 2")
      debugger.method_1

      occurrences = @class.singleton_class.ancestors.count {|a| a.is_a?(Putter::MethodProxy)}
      expect(occurrences).to eq(1)
    end

    it "does not add the proxy to instances of a class" do
      debugger = Putter::ClassDebugger.new(@class)
      test = @class.new
      stub_test_class_methods(@class)

      presence = test.class.ancestors.any? {|a| a.is_a?(Putter::MethodProxy)}

      expect(presence).to be false
    end
  end

  describe "#method_missing" do
    it "adds a method to the proxy" do
      debugger = Putter::ClassDebugger.new(@class)
      stub_test_class_methods(@class)

      debugger.test_class_method

      expect(debugger.proxy.instance_methods).to include(:test_class_method)
    end

    it "only adds the method once" do
      debugger = Putter::ClassDebugger.new(@class)
      stub_test_class_methods(@class)

      expect(debugger).to receive(:add_method).once.and_call_original

      debugger.test_class_method
      debugger.test_class_method
    end
  end

  describe "#add_method" do
    it "defers to log method" do
      debugger = Putter::ClassDebugger.new(@class)

      debugger.add_method(:hello)

      expect(debugger.proxy.instance_methods).to include(:hello)
    end
  end

  describe "#log_method" do
    it "defines a method on the proxy" do
      debugger = Putter::ClassDebugger.new(@class)

      debugger.log_method(:hello)

      expect(debugger.proxy.instance_methods).to include(:hello)
    end

    it "does not call the method" do
      debugger = Putter::ClassDebugger.new(@class)

      expect(@class).to_not receive(:test_class_method)

      debugger.log_method(:test_class_method)
    end

    it "accepts a block" do
      debugger = Putter::ClassDebugger.new(@class)

      debugger.log_method(:test_class_method) do
        puts "I am calling a method"
      end

     expect do
        @class.test_class_method
      end.to output(/I am calling a method/).to_stdout
    end

    it "accepts a block with arguments" do
      debugger = Putter::ClassDebugger.new(@class)

      debugger.log_method(:test_class_method_arg) do |*args|
        puts "Print the args: #{args}"
      end

      expect do
        @class.test_class_method_arg("world")
      end.to output(/Print the args: \["world"\]/).to_stdout
    end
  end
end
