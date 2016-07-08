describe Putter::Follower do
  shared_examples "initialize" do
    context "#initialize" do
      it "sends methods to the wrapped object" do
        follower = get_follower(subject)

        expect(subject).to receive(:test_method)

        follower.test_method
      end

      it "sends arguments to the wrapped object" do
        follower = get_follower(subject)

        expect(subject).to receive(:test_method_arg).with("Hello")

        follower.test_method_arg("Hello")
      end

      it "sends blocks to the wrapped object" do
        follower = get_follower(subject)

        expect(subject).to receive(:test_method_block).and_call_original

        str = ""
        follower.test_method_block do
          str = "Success"
        end
        expect(str).to eq("Success")
      end

      it "sends arguments and blocks to the wrapped object" do
        follower = get_follower(subject)

        expect(subject).to receive(:test_method_block_arg).and_call_original

        str = "Hello "
        follower.test_method_block_arg do |subj|
          str += "#{subj}"
        end

        expect(str).to eq("Hello World")
      end

      it "prepends the proxy only once" do
        follower = get_follower(subject)

        follower.test_method
        follower.test_method_arg("method 2")
        follower.test_method

        occurrences = subject.singleton_class.ancestors.count {|a| a.is_a?(Putter::MethodProxy)}
        expect(occurrences).to eq(1)
      end
    end
  end

  describe "#initialize" do
    it "raises an error when attempting to follow a BasicObject" do
      klass = Class.new(BasicObject)

      expect do
        follower = get_follower(klass.new)
      end.to raise_error(Putter::BasicObjectError)
    end
  end

  shared_examples "method_missing" do
    context "#method_missing" do
      it "adds a method to the proxy" do
        follower = get_follower(subject)

        follower.test_method

        expect(follower.proxy.instance_methods).to include(:test_method)
      end

      it "only adds the method once" do
        follower = get_follower(subject)

        expect(follower).to receive(:add_method).once.and_call_original

        follower.test_method
        follower.test_method
      end

      it "does not add methods from configuration.ignore_methods_from" do
        Putter.configuration.ignore_methods_from = [Object]
        follower = get_follower(subject)

        follower.to_s

        expect(follower.proxy.instance_methods).to_not include(:to_s)
      end

      it "does add methods if configuration.ignore_methods_from is empty" do
        Putter.configuration.ignore_methods_from = []
        follower = get_follower(subject)

        follower.to_s

        expect(follower.proxy.instance_methods).to include(:to_s)
      end

      it "adds whitelist methods" do
        Putter.configuration.ignore_methods_from = [Object]
        ::Putter.configuration.methods_whitelist = [:to_s]
        follower = get_follower(subject)

        follower.to_s

        expect(follower.proxy.instance_methods).to include(:to_s)
      end
    end
  end

  shared_examples "add_method" do
    context "#add_method" do
      it "defines a method on the proxy" do
        follower = get_follower(subject)

        follower.add_method(:hello)

        expect(follower.proxy.instance_methods).to include(:hello)
      end

      it "does not call the method" do
        follower = get_follower(subject)

        expect(subject).to_not receive(:test_method)

        follower.add_method(:test_method)
      end

      it "prints the line without the directory with number" do
        Putter.configuration.print_strategy = Proc.new do |_, line|
          puts "Line: .#{line}"
        end

        follower = get_follower(subject)

        file = __FILE__
        file = file.split(::Dir.pwd)[1]
        expected_line = __LINE__
        expect do
          follower.test_method_arg("world")
        end.to output(/^Line: \.#{file}:#{expected_line + 2}:in `block/).to_stdout
      end

      it "prints the method and args using the configured strategy" do
        Putter.configuration.print_strategy = Proc.new do |_, _, method, args, result|
          puts "Method: :#{method}, Args: #{args}, Result: #{result}"
        end

        follower = get_follower(subject)

        expect do
          follower.test_method_arg("world")
        end.to output(/Method: :test_method_arg, Args: \["world"\]/).to_stdout
      end
    end
  end

  shared_examples "proxied_methods" do
    describe "#proxied_methods" do
      it "proxies all methods if none are specified" do
        follower = get_follower(subject)

        follower.test_method
        follower.test_method_arg("World")

        expect(follower.proxy.instance_methods).to include(:test_method, :test_method_arg)
      end

      it "only proxies specified methods as strings" do
        follower = Putter::Follower.new(subject, methods: ["test_method_arg"])

        follower.test_method
        follower.test_method_arg("World")

        expect(follower.proxy.instance_methods).to include(:test_method_arg)
        expect(follower.proxy.instance_methods).to_not include(:test_method)
      end

      it "accepts symbols" do
        follower = Putter::Follower.new(subject, methods: [:test_method_arg])

        follower.test_method
        follower.test_method_arg("World")

        expect(follower.proxy.instance_methods).to include(:test_method_arg)
      end

      it "calls unfollowed methods on the proxied object" do
        follower = Putter::Follower.new(subject, methods: ["test_method_arg"])

        expect(subject).to receive(:test_method)

        follower.test_method
      end
    end
  end

  describe "instances" do
    subject { Test.new }

    include_examples "initialize"
    include_examples "method_missing"
    include_examples "add_method"
    include_examples "proxied_methods"

    it "does not add the proxy to other instances of a class" do
      proxied_test = Test.new
      non_proxied_test = Test.new
      follower = get_follower(proxied_test)

      follower.test_method

      proxied_test_presence = proxied_test.singleton_class.ancestors.any? {|a| a.is_a?(Putter::MethodProxy)}
      non_proxied_test_presence = non_proxied_test.singleton_class.ancestors.any? {|a| a.is_a?(Putter::MethodProxy)}

      expect(proxied_test_presence).to be true
      expect(non_proxied_test_presence).to be false
    end

    it "returns the correct label for instances" do
      test = Test.new
      follower = Putter::Follower.new(test)

      Putter.configuration.print_strategy = Proc.new do |label|
        puts "Label: #{label}"
      end

      expect do
        follower.test_method
      end.to output(/Label: Test instance/).to_stdout
    end
  end

  describe "classes" do
    subject do
      Class.new do
        def self.test_method
        end

        def self.test_method_arg(arg)
        end

        def self.test_method_block(&blk)
          yield
        end

        def self.test_method_block_arg(&blk)
          yield "World"
        end
      end
    end

    include_examples "initialize"
    include_examples "method_missing"
    include_examples "add_method"
    include_examples "proxied_methods"

    it "does not add the proxy to instances of a class" do
      follower = get_follower(subject)
      test = subject.new

      presence = test.class.ancestors.any? {|a| a.is_a?(Putter::MethodProxy)}

      expect(presence).to be false
    end

    it "returns the correct label for classes" do
      class TestClass1
        def self.test_method
        end
      end
      follower = Putter::Follower.new(TestClass1)

      Putter.configuration.print_strategy = Proc.new do |label|
        puts "Label: #{label}"
      end

      expect do
        follower.test_method
      end.to output(/Label: TestClass1/).to_stdout
    end
  end

  describe "#initialize" do
    it "does not respond to core methods" do
      hash = { a: 1, b: 2 }
      follower = get_follower(hash)

      expect(hash).to receive(:to_json)

      follower.to_json
    end
  end

  describe "#add_method" do
    it "does not print newlines if there is nothing to print" do
      test = Test.new
      follower = get_follower(test)

      expect do
        follower.test_method
      end.to_not output.to_stdout
    end

  end
end
