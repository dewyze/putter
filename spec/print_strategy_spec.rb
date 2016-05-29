RSpec.describe Putter::PrintStrategy do
  describe Putter::PrintStrategy::MethodStrategy do
    it "outputs the header" do
      expect do
        Putter::PrintStrategy::MethodStrategy.call
      end.to output(/\tPutter Debugging:/).to_stdout
    end

    it "outputs the label" do
      expect do
        Putter::PrintStrategy::MethodStrategy.call "My Label"
      end.to output(/My Label/).to_stdout
    end

    it "outputs the '---' break" do
      expect do
        Putter::PrintStrategy::MethodStrategy.call
      end.to output(/-----------------/).to_stdout
    end

    it "outputs the method title" do
      expect do
        Putter::PrintStrategy::MethodStrategy.call
      end.to output(/\t\t  Method:  /).to_stdout
    end

    it "outputs the method" do
      expect do
        Putter::PrintStrategy::MethodStrategy.call nil, :method
      end.to output(/:method/).to_stdout
    end

    it "outputs the Args title" do
      expect do
        Putter::PrintStrategy::MethodStrategy.call
      end.to output(/\t\t    Args:  /).to_stdout
    end

    it "outputs the args as an array" do
      expect do
        Putter::PrintStrategy::MethodStrategy.call nil, :method, ["Hello", :World, 1]
      end.to output(/\["Hello", :World, 1\]/).to_stdout
    end
  end

  describe Putter::PrintStrategy::ResultStrategy do
    it "outputs the Result title" do
      expect do
        Putter::PrintStrategy::ResultStrategy.call
      end.to output(/\t\t  Result:  /).to_stdout
    end

    it "outputs the Result vaule" do
      expect do
        Putter::PrintStrategy::ResultStrategy.call "Hello World"
      end.to output(/Hello World/).to_stdout
    end
  end
end
