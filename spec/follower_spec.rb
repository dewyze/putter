require "spec_helper"

describe Putter::Follower do
  context "instances" do
    describe "initialize" do
      it "sends methods to the wrapped object" do
        test = Test.new
        follower = Putter::Follower.new(test)

        expect(test).to receive(:test_instance_method)

        follower.test_instance_method
      end

      it "sends arguments to the wrapped object" do
        test = Test.new
        follower = Putter::Follower.new(test)

        expect(test).to receive(:test_instance_method_arg).with("Hello")

        follower.test_instance_method_arg("Hello")
      end

      it "sends blocks to the wrapped object" do
        test = Test.new
        follower = Putter::Follower.new(test)

        expect(test).to receive(:test_instance_method_block).and_call_original

        str = ""
        follower.test_instance_method_block do
          str = "Success"
        end
        expect(str).to eq("Success")
      end

      it "sends arguments and blocks to the wrapped object" do
        test = Test.new
        follower = Putter::Follower.new(test)

        expect(test).to receive(:test_instance_method_block_arg).and_call_original

        str = "Hello "
        follower.test_instance_method_block_arg do |subj|
          str += "#{subj}"
        end

        expect(str).to eq("Hello World")
      end

      it "prepends the proxy only once" do
        test = Test.new
        follower = Putter::Follower.new(test)
        stub_test_instance_methods(test)

        follower.test_instance_method
        follower.test_instance_method_arg("method 2")
        follower.test_instance_method

        occurrences = test.singleton_class.ancestors.count {|a| a.is_a?(Putter::MethodProxy)}
        expect(occurrences).to eq(1)
      end

      it "does not add the proxy to other instances of a class" do
        proxied_test = Test.new
        non_proxied_test = Test.new
        follower = Putter::Follower.new(proxied_test)
        stub_test_instance_methods(proxied_test)
        stub_test_instance_methods(non_proxied_test)

        follower.test_instance_method

        proxied_test_presence = proxied_test.singleton_class.ancestors.any? {|a| a.is_a?(Putter::MethodProxy)}
        non_proxied_test_presence = non_proxied_test.singleton_class.ancestors.any? {|a| a.is_a?(Putter::MethodProxy)}

        expect(proxied_test_presence).to be true
        expect(non_proxied_test_presence).to be false
      end
    end

    describe "#method_missing" do
      it "adds a method to the proxy" do
        test = Test.new
        follower = Putter::Follower.new(test)
        stub_test_instance_methods(test)

        follower.test_instance_method

        expect(follower.proxy.instance_methods).to include(:test_instance_method)
      end

      it "only adds the method once" do
        test = Test.new
        follower = Putter::Follower.new(test)
        stub_test_instance_methods(test)

        expect(follower).to receive(:add_method).once.and_call_original

        follower.test_instance_method
        follower.test_instance_method
      end
    end

    describe "#add_method" do
      it "defers to log method" do
        test = Test.new
        follower = Putter::Follower.new(test)

        follower.add_method(:hello)

        expect(follower.proxy.instance_methods).to include(:hello)
      end
    end

    describe "#log_method" do
      it "defines a method on the proxy" do
        test = Test.new
        follower = Putter::Follower.new(test)

        follower.log_method(:hello)

        expect(follower.proxy.instance_methods).to include(:hello)
      end

      it "does not call the method" do
        test = Test.new
        follower = Putter::Follower.new(test)

        expect(test).to_not receive(:test_instance_method)

        follower.log_method(:test_instance_method)
      end

      it "accepts a block" do
        test = Test.new
        follower = Putter::Follower.new(test)

        follower.log_method(:test_instance_method) do
          puts "I am calling a method"
        end

        expect do
          test.test_instance_method
        end.to output(/I am calling a method/).to_stdout
      end

      it "accepts a block with arguments" do
        test = Test.new
        follower = Putter::Follower.new(test)

        follower.log_method(:test_instance_method_arg) do |*args|
          puts "Print the args: #{args}"
        end

        expect do
          test.test_instance_method_arg("world")
        end.to output(/Print the args: \["world"\]/).to_stdout
      end
    end
  end

  context "classes" do
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
        follower = Putter::Follower.new(@class)

        expect(@class).to receive(:test_class_method)

        follower.test_class_method
      end

      it "sends arguments to the wrapped object" do
        follower = Putter::Follower.new(@class)

        expect(@class).to receive(:test_class_method_arg).with("Hello")

        follower.test_class_method_arg("Hello")
      end

      it "sends blocks to the wrapped object" do
        follower = Putter::Follower.new(@class)

        expect(@class).to receive(:test_class_method_block).and_call_original

        str = ""
        follower.test_class_method_block do
          str = "Success"
        end
        expect(str).to eq("Success")
      end

      it "sends arguments and blocks to the wrapped object" do
        follower = Putter::Follower.new(@class)

        expect(@class).to receive(:test_class_method_block_arg).and_call_original

        str = "Hello "
        follower.test_class_method_block_arg do |subj|
          str += "#{subj}"
        end

        expect(str).to eq("Hello World")
      end

      it "prepends the proxy only once" do
        follower = Putter::Follower.new(@class)
        allow(@class).to receive(:method_1)
        allow(@class).to receive(:method_2)

        follower.method_1
        follower.method_2("method 2")
        follower.method_1

        occurrences = @class.singleton_class.ancestors.count {|a| a.is_a?(Putter::MethodProxy)}
        expect(occurrences).to eq(1)
      end

      it "does not add the proxy to instances of a class" do
        follower = Putter::Follower.new(@class)
        test = @class.new
        stub_test_class_methods(@class)

        presence = test.class.ancestors.any? {|a| a.is_a?(Putter::MethodProxy)}

        expect(presence).to be false
      end
    end

    describe "#method_missing" do
      it "adds a method to the proxy" do
        follower = Putter::Follower.new(@class)
        stub_test_class_methods(@class)

        follower.test_class_method

        expect(follower.proxy.instance_methods).to include(:test_class_method)
      end

      it "only adds the method once" do
        follower = Putter::Follower.new(@class)
        stub_test_class_methods(@class)

        expect(follower).to receive(:add_method).once.and_call_original

        follower.test_class_method
        follower.test_class_method
      end
    end

    describe "#add_method" do
      it "defers to log method" do
        follower = Putter::Follower.new(@class)

        follower.add_method(:hello)

        expect(follower.proxy.instance_methods).to include(:hello)
      end
    end

    describe "#log_method" do
      it "defines a method on the proxy" do
        follower = Putter::Follower.new(@class)

        follower.log_method(:hello)

        expect(follower.proxy.instance_methods).to include(:hello)
      end

      it "does not call the method" do
        follower = Putter::Follower.new(@class)

        expect(@class).to_not receive(:test_class_method)

        follower.log_method(:test_class_method)
      end

      it "accepts a block" do
        follower = Putter::Follower.new(@class)

        follower.log_method(:test_class_method) do
          puts "I am calling a method"
        end

        expect do
          @class.test_class_method
        end.to output(/I am calling a method/).to_stdout
      end

      it "accepts a block with arguments" do
        follower = Putter::Follower.new(@class)

        follower.log_method(:test_class_method_arg) do |*args|
          puts "Print the args: #{args}"
        end

        expect do
          @class.test_class_method_arg("world")
        end.to output(/Print the args: \["world"\]/).to_stdout
      end
    end
  end
end
