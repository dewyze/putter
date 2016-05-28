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
  end
end
