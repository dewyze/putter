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

      it "passes options" do
        options = {
          label: "My label",
          methods: [:to_s],
        }

        expect(Putter::Follower).to receive(:new).with(subject, options)

        Putter.follow(subject, options)
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

  describe "#watch" do
    it "calls Watcher to watch a class" do
      klass = Class.new
      expect(Putter::Watcher).to receive(:watch)

      Putter.watch(klass)
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
