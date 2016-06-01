RSpec.describe Putter::Configuration do
  describe "#initialize" do
    it "initializes with the default print method call strategy" do
      configuration = Putter::Configuration.new

      expect(configuration.method_strategy).to eq(Putter::PrintStrategy::MethodStrategy)
    end

    it "initializes with the default print result call strategy" do
      configuration = Putter::Configuration.new

      expect(configuration.result_strategy).to eq(Putter::PrintStrategy::ResultStrategy)
    end

    it "initializes with print_results true" do
      configuration = Putter::Configuration.new

      expect(configuration.print_results).to eq(true)
    end

    it "initializes ignore_methods_from with 'Object'" do
      configuration = Putter::Configuration.new

      expect(configuration.ignore_methods_from).to eq([Object])
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
end
