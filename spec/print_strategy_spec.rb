RSpec.describe Putter::PrintStrategy do
  describe Putter::PrintStrategy::MethodStrategy do
    it "prints the output" do
      expect(Putter::PrintStrategy::MethodStrategy.call "my_label", :method, ["Hello", :World, 1])
        .to match(/Putter Debugging: .*my_label -- Method: :method, Args: \["Hello", :World, 1\]/)
    end
  end

  describe Putter::PrintStrategy::ResultStrategy do
    it "outputs the Result title" do
      expect(Putter::PrintStrategy::ResultStrategy.call "Hello World")
        .to match(/Result: .*Hello World/)
    end
  end
end
