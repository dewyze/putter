require "spec_helper"

describe Putter::ClassDebugger do
  describe "initialize" do
    it "sends methods to the wrapped object" do
      debugger = Putter::ClassDebugger.new(TestClass)

      expect(TestClass).to receive(:test_class_method)

      debugger.test_class_method
    end

    it "sends arguments to the wrapped object" do
      debugger = Putter::ClassDebugger.new(TestClass)

      expect(TestClass).to receive(:test_class_method_arg).with("Hello")

      debugger.test_class_method_arg("Hello")
    end

    it "sends blocks to the wrapped object" do
      debugger = Putter::ClassDebugger.new(TestClass)

      expect(TestClass).to receive(:test_class_method_block).and_call_original

      str = ""
      debugger.test_class_method_block do
        str = "Success"
      end
      expect(str).to eq("Success")
    end

    it "sends arguments and blocks to the wrapped object" do
      debugger = Putter::ClassDebugger.new(TestClass)

      expect(TestClass).to receive(:test_class_method_block_arg).and_call_original

      str = "Hello "
      debugger.test_class_method_block_arg do |subj|
        str += "#{subj}"
      end

      expect(str).to eq("Hello World")
    end

    it "prepends the proxy only once" do
      class ProxyOnlyOnce
        def self.method_1
        end

        def self.method_2(arg)
        end
      end

      debugger = Putter::ClassDebugger.new(ProxyOnlyOnce)
      allow(ProxyOnlyOnce).to receive(:method_1)
      allow(ProxyOnlyOnce).to receive(:method_2)

      debugger.method_1
      debugger.method_2("method 2")
      debugger.method_1

      occurrences = ProxyOnlyOnce.singleton_class.ancestors.count {|a| a.is_a?(Putter::MethodProxy)}
      expect(occurrences).to eq(1)
    end

    it "does not add the proxy to instances of a class" do
      debugger = Putter::ClassDebugger.new(TestClass)
      test = TestClass.new
      stub_test_class_methods
      stub_test_instance_methods(test)

      presence = test.class.ancestors.any? {|a| a.is_a?(Putter::MethodProxy)}

      expect(presence).to be false
    end
  end

  describe "#method_missing" do
    it "adds a method to the proxy" do
      debugger = Putter::ClassDebugger.new(TestClass)
      stub_test_class_methods

      debugger.test_class_method

      expect(debugger.proxy.instance_methods).to include(:test_class_method)
    end

    it "only adds the method once" do
      debugger = Putter::ClassDebugger.new(TestClass)
      stub_test_class_methods

      expect(debugger).to receive(:add_method).once.and_call_original

      debugger.test_class_method
      debugger.test_class_method
    end
  end

  describe "#add_method" do
    it "defers to log method" do
      debugger = Putter::ClassDebugger.new(TestClass)

      debugger.add_method(:hello)

      expect(debugger.proxy.instance_methods).to include(:hello)
    end
  end

  describe "#log_method" do
    it "defines a method on the proxy" do
      debugger = Putter::ClassDebugger.new(TestClass)

      debugger.log_method(:hello)

      expect(debugger.proxy.instance_methods).to include(:hello)
    end

    it "does not call the method" do
      test = TestClass.new
      debugger = Putter::ClassDebugger.new(test)

      expect(test).to_not receive(:test_class_method)

      debugger.log_method(:test_class_method)
    end

    it "accepts a block" do
      debugger = Putter::ClassDebugger.new(TestClass)

      debugger.log_method(:test_class_method) do
        puts "I am calling a method"
      end

     expect do
        TestClass.test_class_method
      end.to output(/I am calling a method/).to_stdout
    end

    it "accepts a block with arguments" do
      debugger = Putter::ClassDebugger.new(TestClass)

      debugger.log_method(:test_class_method_arg) do |*args|
        puts "Print the args: #{args}"
      end

      expect do
        TestClass.test_class_method_arg("world")
      end.to output(/Print the args: \["world"\]/).to_stdout
    end
  end
end
