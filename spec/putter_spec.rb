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
        Putter.configuration.print_strategy = Putter::PrintStrategy::Testing
        follower = Putter.follow(subject, methods: [:test_method_arg])

        expect do
          follower.test_method_arg("World")
        end.to output(/Method: :test_method_arg, Args: \["World"\]/).to_stdout
      end

      it "ignores unspecified methods" do
        Putter.configuration.print_strategy = Putter::PrintStrategy::Testing
        follower = Putter.follow(subject, methods: [:test_method])

        expect do
          follower.test_method_arg("World")
        end.to_not output(/:test_method_arg/).to_stdout
      end

      it "prints debugging info" do
        Putter.configuration.print_strategy = Putter::PrintStrategy::Testing
        follower = Putter.follow(subject)

        expect do
          follower.test_method
          follower.test_method_arg("earth")
        end.to output(/Method: :test_method, Args: \[\], Result: Hello World!\nMethod: :test_method_arg, Args: \["earth"\], Result: Hello earth!/m).to_stdout
      end

      it "prints the label option if it is present" do
        Putter.configuration.print_strategy = Putter::PrintStrategy::Default
        follower = Putter.follow(subject, label: "custom label")

        expect do
          follower.test_method
        end.to output(/Putter Debugging: .*custom label/).to_stdout
      end

      it "prints the line and number" do
        Putter.configuration.print_strategy = Putter::PrintStrategy::Default
        follower = Putter.follow(subject)

        file = __FILE__
        file = file.split(::Dir.pwd)[1]
        expect do
          follower.test_method
        end.to output(/Putter Debugging: .*\.#{file}:#{__LINE__ - 1}.* Method:/).to_stdout
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
      @print_strategy = Proc.new do |obj, method, args, result|
        puts "Obj: #{obj}, Method: #{method}, Args: #{args}, Result: #{result}"
      end

      Putter.configure do |config|
        config.print_strategy = @print_strategy
        config.ignore_methods_from = nil
        config.methods_whitelist = [:to_s]
      end
    end

    it "prints method calls with the configured strategy" do
      expect(Putter.configuration.print_strategy).to eq(@print_strategy)
    end

    it "ignores methods from the configured classes" do
      expect(Putter.configuration.ignore_methods_from).to eq([])
    end

    it "whitelists configure methods" do
      expect(Putter.configuration.methods_whitelist).to eq([:to_s])
    end

    describe "#reset" do
      it "resets the configuration" do
        Putter.reset_configuration

        expect(Putter.configuration.print_strategy).to eq(Putter::PrintStrategy::Default)
      end
    end
  end
end
