describe Putter do
  it 'has a version number' do
    expect(Putter::VERSION).not_to be nil
  end

  shared_examples "follow" do
    describe "#follow" do
      it "creates a follower for the object" do
        follower = get_follower(subject)

        expect(follower.object).to eq(subject)
      end

      it "creates a method proxy" do
        follower = Putter.follow(subject)

        expect(subject.singleton_class.ancestors.first).to be_an_instance_of(Putter::MethodProxy)
      end

      it "accepts specific methods" do
        Putter.configuration.method_strategy = Putter::PrintStrategy::MethodTesting
        follower = Putter.follow(subject, methods: [:test_method_arg])

        expect do
          follower.test_method_arg("World")
        end.to output(/Method: :test_method_arg, Args: \["World"\]/).to_stdout
      end

      it "ignores unspecified methods" do
        Putter.configuration.method_strategy = Putter::PrintStrategy::MethodTesting
        follower = Putter.follow(subject, methods: [:test_method])

        expect do
          follower.test_method_arg("World")
        end.to_not output(/:test_method_arg/).to_stdout
      end

      it "prints debugging info for method calls" do
        Putter.configuration.method_strategy = Putter::PrintStrategy::MethodTesting
        follower = Putter.follow(subject)

        expect do
          follower.test_method
          follower.test_method_arg("World")
        end.to output(/Method: :test_method, Args: \[\]\nMethod: :test_method_arg, Args: \["World"\]/m).to_stdout
      end

      it "prints the debugging info for results" do
        Putter.configure do |config|
          config.result_strategy = Putter::PrintStrategy::ResultTesting
          config.print_results = true
        end
        follower = Putter.follow(subject)

        expect do
          follower.test_method
        end.to output(/Result: Hello World!/).to_stdout
      end

      it "does not print debugging info if print results is false" do
        Putter.configure do |config|
          config.result_strategy = Putter::PrintStrategy::ResultTesting
          config.print_results = false
        end
        follower = Putter.follow(subject)

        expect do
          follower.test_method
        end.to_not output(/Result: Hello World!/).to_stdout
      end

      it "prints the label option if it is present" do
        Putter.configuration.method_strategy = Putter::PrintStrategy::MethodStrategy
        follower = Putter.follow(subject, label: "custom label")

        expect do
          follower.test_method
        end.to output(/\n.*Putter Debugging:.*custom label/).to_stdout
      end
    end
  end


  describe "#follow" do
    context "instances" do
      subject { Test.new }

      include_examples "follow"
    end

    context "classes" do
      subject do
        Class.new do
          def self.test_method
            "Hello World!"
          end

          def self.test_method_arg(arg)
            "Hello #{arg}!"
          end

          def self.test_method_block(&blk)
            yield
          end

          def self.test_method_block_arg(&blk)
            yield "World"
          end
        end
      end

      include_examples "follow"
    end
  end

  describe "configuration" do
    before(:each) do
      @method_strategy = Proc.new do |obj, method, args|
        puts "Obj: #{obj}, Method: #{method}, Args: #{args}"
      end
      @result_strategy = Proc.new do |result|
        puts "Result: #{result}"
      end

      Putter.configure do |config|
        config.print_results = false
        config.method_strategy = @method_strategy
        config.result_strategy = @result_strategy
        config.ignore_methods_from = nil
      end
    end

    it "does not print results" do
      expect(Putter.configuration.print_results).to be false
    end

    it "prints method calls with the configured strategy" do
      expect(Putter.configuration.method_strategy).to eq(@method_strategy)
    end

    it "prints results with the configured strategy" do
      expect(Putter.configuration.result_strategy).to eq(@result_strategy)
    end

    it "ignores methods from the configured classes" do
      expect(Putter.configuration.ignore_methods_from).to eq([])
    end

    describe "#reset" do
      it "resets the configuration" do
        Putter.reset_configuration

        expect(Putter.configuration.print_results).to be true
        expect(Putter.configuration.method_strategy).to eq(Putter::PrintStrategy::MethodStrategy)
        expect(Putter.configuration.result_strategy).to eq(Putter::PrintStrategy::ResultStrategy)
      end
    end
  end
end
