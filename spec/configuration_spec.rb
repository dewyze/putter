RSpec.describe Putter::Configuration do
  describe "#initialize" do
    it "initializes with the default print method call strategy" do
      configuration = Putter::Configuration.new

      expect(configuration.print_strategy).to eq(Putter::PrintStrategy::Default)
    end

    it "initializes ignore_methods_from with 'Object'" do
      configuration = Putter::Configuration.new

      expect(configuration.ignore_methods_from).to contain_exactly(Object)
    end

    context "in rails" do
      around(:each) do |spec|
        class ActiveRecord
          class Base
          end
        end

        spec.run

        Object.send(:remove_const, :ActiveRecord)
      end

      it "initializes ignore_methods_from with 'ActivedRecord::Base' if it exists" do
        configuration = nil
        configuration = Putter::Configuration.new

        expect(configuration.ignore_methods_from).to contain_exactly(Object, ActiveRecord::Base)
      end
    end

    it "initializes methods_whitelist with []" do
      configuration = Putter::Configuration.new

      expect(configuration.methods_whitelist).to eq([])
    end

    it "initializes methods_blacklist with []" do
      configuration = Putter::Configuration.new

      expect(configuration.methods_blacklist).to eq([])
    end
  end

  describe "#ignore_methods_from" do
    it "returns an empty array when ignore_methods_from is nil" do
      ::Putter.configuration.ignore_methods_from = nil

      expect(::Putter.configuration.ignore_methods_from).to match_array([])
    end

    it "returns an array when ignore_methods_from is an object" do
      ::Putter.configuration.ignore_methods_from = Object

      expect(::Putter.configuration.ignore_methods_from).to match_array([Object])
    end

    it "returns an array when ignore_methods_from is an array" do
      ::Putter.configuration.ignore_methods_from = [Object, Test]

      expect(::Putter.configuration.ignore_methods_from).to match_array([Object, Test])
    end
  end

  describe "#methods_whitelist" do
    it "returns the methods whitelist array" do
      ::Putter.configuration.methods_whitelist = [:to_s]

      expect(::Putter.configuration.methods_whitelist).to match_array([:to_s])
    end

    it "returns an MethodConflictError if methods are blacklisted" do
      ::Putter.configuration.methods_blacklist = [:to_s]

      expect do
        ::Putter.configuration.methods_whitelist = [:to_s]
      end.to raise_error(::Putter::MethodConflictError)
    end
  end

  describe "#methods_blacklist" do
    it "returns the methods_blacklist array" do
      ::Putter.configuration.methods_blacklist = [:to_s]

      expect(::Putter.configuration.methods_blacklist).to match_array([:to_s])
    end

    it "returns an MethodConflictError if methods are whitelisted" do
      ::Putter.configuration.methods_whitelist = [:to_s]

      expect do
        ::Putter.configuration.methods_blacklist = [:to_s]
      end.to raise_error(::Putter::MethodConflictError)
    end
  end

  describe "#allow_production" do
    around(:each) do |spec|
      class ActiveRecord
        class Base
        end
      end

      spec.run

      Object.send(:remove_const, :ActiveRecord)
    end

    it "returns false by default" do
      expect(::Putter.configuration.allow_production).to be false
    end

    it "allows it to be set to true" do
      ::Putter.configuration.allow_production = true

      expect(::Putter.configuration.allow_production).to be true
    end
  end
end
