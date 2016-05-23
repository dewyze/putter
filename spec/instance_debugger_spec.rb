require "spec_helper"

describe Putter::InstanceDebugger do
  describe "initialize" do
    it "sends methods to the wrapped object" do
      test = Test.new
      debugger = Putter::InstanceDebugger.new(test)

      expect(test).to receive(:test_instance_method)

      debugger.test_instance_method
    end

    it "sends arguments to the wrapped object" do
      test = Test.new
      debugger = Putter::InstanceDebugger.new(test)

      expect(test).to receive(:test_instance_method_arg).with("Hello")

      debugger.test_instance_method_arg("Hello")
    end

    it "sends blocks to the wrapped object" do
      test = Test.new
      debugger = Putter::InstanceDebugger.new(test)

      expect(test).to receive(:test_instance_method_block).and_call_original

      str = ""
      debugger.test_instance_method_block do
        str = "Success"
      end
      expect(str).to eq("Success")
    end

    it "sends arguments and blocks to the wrapped object" do
      test = Test.new
      debugger = Putter::InstanceDebugger.new(test)

      expect(test).to receive(:test_instance_method_block_arg).and_call_original

      str = "Hello "
      debugger.test_instance_method_block_arg do |subj|
        str += "#{subj}"
      end

      expect(str).to eq("Hello World")
    end

    it "prepends the proxy only once" do
      test = Test.new
      debugger = Putter::InstanceDebugger.new(test)
      stub_test_instance_methods(test)

      debugger.test_instance_method
      debugger.test_instance_method_arg("method 2")
      debugger.test_instance_method

      occurrences = test.singleton_class.ancestors.count {|a| a.is_a?(Putter::MethodProxy)}
      expect(occurrences).to eq(1)
    end

    it "does not add the proxy to other instances of a class" do
      proxied_test = Test.new
      non_proxied_test = Test.new
      debugger = Putter::InstanceDebugger.new(proxied_test)
      stub_test_instance_methods(proxied_test)
      stub_test_instance_methods(non_proxied_test)

      debugger.test_instance_method

      proxied_test_presence = proxied_test.singleton_class.ancestors.any? {|a| a.is_a?(Putter::MethodProxy)}
      non_proxied_test_presence = non_proxied_test.singleton_class.ancestors.any? {|a| a.is_a?(Putter::MethodProxy)}

      expect(proxied_test_presence).to be true
      expect(non_proxied_test_presence).to be false
    end
  end

  describe "#method_missing" do
    it "adds a method to the proxy" do
      test = Test.new
      debugger = Putter::InstanceDebugger.new(test)
      stub_test_instance_methods(test)

      debugger.test_instance_method

      expect(debugger.proxy.instance_methods).to include(:test_instance_method)
    end

    it "only adds the method once" do
      test = Test.new
      debugger = Putter::InstanceDebugger.new(test)
      stub_test_instance_methods(test)

      expect(debugger).to receive(:add_method).once.and_call_original

      debugger.test_instance_method
      debugger.test_instance_method
    end
  end

  describe "#add_method" do
    it "defers to log method" do
      test = Test.new
      debugger = Putter::InstanceDebugger.new(test)

      debugger.add_method(:hello)

      expect(debugger.proxy.instance_methods).to include(:hello)
    end
  end

  describe "#log_method" do
    it "defines a method on the proxy" do
      test = Test.new
      debugger = Putter::InstanceDebugger.new(test)

      debugger.log_method(:hello)

      expect(debugger.proxy.instance_methods).to include(:hello)
    end

    it "does not call the method" do
      test = Test.new
      debugger = Putter::InstanceDebugger.new(test)

      expect(test).to_not receive(:test_instance_method)

      debugger.log_method(:test_instance_method)
    end

    it "accepts a block" do
      test = Test.new
      debugger = Putter::InstanceDebugger.new(test)

      debugger.log_method(:test_instance_method) do
        puts "I am calling a method"
      end

     expect do
        test.test_instance_method
      end.to output(/I am calling a method/).to_stdout
    end

    it "accepts a block with arguments" do
      test = Test.new
      debugger = Putter::InstanceDebugger.new(test)

      debugger.log_method(:test_instance_method_arg) do |*args|
        puts "Print the args: #{args}"
      end

      expect do
        test.test_instance_method_arg("world")
      end.to output(/Print the args: \["world"\]/).to_stdout
    end
  end
end
