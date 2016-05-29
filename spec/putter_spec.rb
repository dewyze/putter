describe Putter do
  it 'has a version number' do
    expect(Putter::VERSION).not_to be nil
  end

  describe "#follow" do
    context "instances" do
      it "creates a follower for the object" do
        test = Test.new
        follower = Putter.follow(test)

        expect(follower.object).to eq(test)
      end

      it "creates a method proxy" do
        test = Test.new
        follower = Putter.follow(test)

        expect(test.singleton_class.ancestors.first).to be_an_instance_of(Putter::MethodProxy)
      end

      it "accepts specific methods" do
        test = Test.new
        follower = Putter.follow(test, methods: [:test_method_arg])

        expect do
          follower.test_method_arg("World")
        end.to output(/Method:.*:test_method_arg.*\n.*Args:.*\["World"\]/).to_stdout
      end

      it "ignores unspecified methods" do
        test = Test.new
        follower = Putter.follow(test, methods: [:test_method])

        expect do
          follower.test_method_arg("World")
        end.to_not output(/:test_method_args\n.*World/).to_stdout
      end

      it "prints debugging info for method calls" do
        test = Test.new
        follower = Putter.follow(test)

        expect do
          follower.test_method
        end.to output(/Method:.*:test_method/).to_stdout

        expect do
          follower.test_method_arg("World")
        end.to output(/:test_method_arg.*\n.*World/).to_stdout
      end
    end

    context "classes" do
      before(:each) do
        @class = Class.new do
          def self.test_method
          end

          def self.test_method_arg(arg)
          end
        end
      end

      it "creates a follower for the object" do
        follower = Putter.follow(@class)

        expect(follower.object).to eq(@class)
      end

      it "creates a method proxy" do
        follower = Putter.follow(@class)

        expect(@class.singleton_class.ancestors.first).to be_an_instance_of(Putter::MethodProxy)
      end

      it "accepts specific methods" do
        follower = Putter.follow(@class, methods: [:test_method_arg])

        expect do
          follower.test_method_arg("World")
        end.to output(/Method:.*:test_method_arg.*\n.*Args:.*\["World"\]/).to_stdout
      end

      it "ignores unspecified methods" do
        follower = Putter.follow(@class, methods: [:test_method])

        expect do
          follower.test_method_arg("World")
        end.to_not output(/:test_method_args\n.*World/).to_stdout
      end

      it "prints debugging info for method calls" do
        follower = Putter.follow(@class)

        expect do
          follower.test_method
        end.to output(/Method:.*:test_method/).to_stdout

        expect do
          follower.test_method_arg("World")
        end.to output(/:test_method_arg.*\n.*World/).to_stdout
      end
    end
  end

  describe "configure" do
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
  end
end
