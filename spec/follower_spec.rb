describe Putter::Follower do
  shared_examples "initialize" do
    context "#initialize" do
      it "sends methods to the wrapped object" do
        follower = Putter::Follower.new(subject, strategy: Putter::PrintStrategy::Testing)

        expect(subject).to receive(:test_method)

        follower.test_method
      end

      it "sends arguments to the wrapped object" do
        follower = Putter::Follower.new(subject, strategy: Putter::PrintStrategy::Testing)

        expect(subject).to receive(:test_method_arg).with("Hello")

        follower.test_method_arg("Hello")
      end

      it "sends blocks to the wrapped object" do
        follower = Putter::Follower.new(subject, strategy: Putter::PrintStrategy::Testing)

        expect(subject).to receive(:test_method_block).and_call_original

        str = ""
        follower.test_method_block do
          str = "Success"
        end
        expect(str).to eq("Success")
      end

      it "sends arguments and blocks to the wrapped object" do
        follower = Putter::Follower.new(subject, strategy: Putter::PrintStrategy::Testing)

        expect(subject).to receive(:test_method_block_arg).and_call_original

        str = "Hello "
        follower.test_method_block_arg do |subj|
          str += "#{subj}"
        end

        expect(str).to eq("Hello World")
      end

      it "prepends the proxy only once" do
        follower = Putter::Follower.new(subject, strategy: Putter::PrintStrategy::Testing)
        stub_methods(subject)

        follower.test_method
        follower.test_method_arg("method 2")
        follower.test_method

        occurrences = subject.singleton_class.ancestors.count {|a| a.is_a?(Putter::MethodProxy)}
        expect(occurrences).to eq(1)
      end

    end
  end

  shared_examples "method_missing" do
    context "#method_missing" do
      it "adds a method to the proxy" do
        follower = Putter::Follower.new(subject, strategy: Putter::PrintStrategy::Testing)
        stub_methods(subject)

        follower.test_method

        expect(follower.proxy.instance_methods).to include(:test_method)
      end

      it "only adds the method once" do
        follower = Putter::Follower.new(subject, strategy: Putter::PrintStrategy::Testing)
        stub_methods(subject)

        expect(follower).to receive(:add_method).once.and_call_original

        follower.test_method
        follower.test_method
      end
    end
  end

  shared_examples "add_method" do
    context "#add_method" do
      it "defers to log method" do
        follower = Putter::Follower.new(subject, strategy: Putter::PrintStrategy::Testing)

        follower.add_method(:hello)

        expect(follower.proxy.instance_methods).to include(:hello)
      end
    end
  end

  shared_examples "log_method" do
    context "#log_method" do
      it "defines a method on the proxy" do
        follower = Putter::Follower.new(subject, strategy: Putter::PrintStrategy::Testing)

        follower.log_method(:hello)

        expect(follower.proxy.instance_methods).to include(:hello)
      end

      it "does not call the method" do
        follower = Putter::Follower.new(subject, strategy: Putter::PrintStrategy::Testing)

        expect(subject).to_not receive(:test_method)

        follower.log_method(:test_method)
      end

      it "accepts a block" do
        follower = Putter::Follower.new(subject, strategy: Putter::PrintStrategy::Testing)

        follower.log_method(:test_method) do
          puts "I am calling a method"
        end

        expect do
          subject.test_method
        end.to output(/I am calling a method/).to_stdout
      end

      it "accepts a block with arguments" do
        follower = Putter::Follower.new(subject, strategy: Putter::PrintStrategy::Testing)

        follower.log_method(:test_method_arg) do |subject, method, args|
          puts "Obj: #{subject}, Method: :#{method}, Args: #{args}"
        end

        expect do
          subject.test_method_arg("world")
        end.to output(/Obj: #{subject}, Method: :test_method_arg, Args: \["world"\]/).to_stdout
      end
    end
  end

  describe "instances" do
    subject { Test.new }

    include_examples "initialize"
    include_examples "method_missing"
    include_examples "add_method"
    include_examples "log_method"

    it "does not add the proxy to other instances of a class" do
      proxied_test = Test.new
      non_proxied_test = Test.new
      follower = Putter::Follower.new(proxied_test, strategy: Putter::PrintStrategy::Testing)
      stub_methods(proxied_test)
      stub_methods(non_proxied_test)

      follower.test_method

      proxied_test_presence = proxied_test.singleton_class.ancestors.any? {|a| a.is_a?(Putter::MethodProxy)}
      non_proxied_test_presence = non_proxied_test.singleton_class.ancestors.any? {|a| a.is_a?(Putter::MethodProxy)}

      expect(proxied_test_presence).to be true
      expect(non_proxied_test_presence).to be false
    end
  end

  describe "classes" do
    subject do
      Class.new do
        def self.test_method
          puts "test_class_method"
        end

        def self.test_method_arg(arg)
          puts "test_class_method_arg: #{arg}"
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
    include_examples "log_method"

    it "does not add the proxy to instances of a class" do
      follower = Putter::Follower.new(subject, strategy: Putter::PrintStrategy::Testing)
      test = subject.new
      stub_methods(subject)

      presence = test.class.ancestors.any? {|a| a.is_a?(Putter::MethodProxy)}

      expect(presence).to be false
    end
  end

  describe "#initialize" do
    it "does not respond to core methods" do
      hash = { a: 1, b: 2 }
      follower = Putter::Follower.new(hash, strategy: Putter::PrintStrategy::Testing)

      expect(hash).to receive(:to_json)

      follower.to_json
    end
  end
end

