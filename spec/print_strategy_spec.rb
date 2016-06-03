RSpec.describe Putter::PrintStrategy do
  describe Putter::PrintStrategy::MethodStrategy do
    it "prints the output" do
      expect do
        Putter::PrintStrategy::MethodStrategy.call "my_label", :method, ["Hello", :World, 1]
      end.to output(/Putter Debugging: .*my_label -- Method: :method, Args: \["Hello", :World, 1\]/).to_stdout
    end
  end

  describe Putter::PrintStrategy::ResultStrategy do
    it "outputs the Result title" do
      expect do
        Putter::PrintStrategy::ResultStrategy.call "Hello World"
      end.to output(/\t          Result: .*Hello World/).to_stdout
    end
  end
end
