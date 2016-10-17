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
  end

  describe "#ignore_methods_from" do
    it "returns an empty array when ignore_methods_from is nil" do
      ::Putter.configuration.ignore_methods_from = nil

      expect(::Putter.configuration.ignore_methods_from).to eq([])
    end

    it "returns an array when ignore_methods_from is an object" do
      ::Putter.configuration.ignore_methods_from = Object

      expect(::Putter.configuration.ignore_methods_from).to eq([Object])
    end

    it "returns an array when ignore_methods_from is an array" do
      ::Putter.configuration.ignore_methods_from = [Object, Test]

      expect(::Putter.configuration.ignore_methods_from).to eq([Object, Test])
    end
  end

  describe "#methods_whitelist" do
    it "returns an empty array when methods_whitelist is nil" do
      ::Putter.configuration.methods_whitelist = nil

      expect(::Putter.configuration.methods_whitelist).to eq([])
    end

    it "returns an array when methods_whitelist is an object" do
      ::Putter.configuration.methods_whitelist = Object

      expect(::Putter.configuration.methods_whitelist).to eq([Object])
    end

    it "returns an array when methods_whitelist is an array" do
      ::Putter.configuration.methods_whitelist = [Object, Test]

      expect(::Putter.configuration.methods_whitelist).to eq([Object, Test])
    end
  end
end
