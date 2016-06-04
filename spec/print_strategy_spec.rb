RSpec.describe Putter::PrintStrategy do
  describe Putter::PrintStrategy::Default do
    it "prints the output" do
      expect do
        Putter::PrintStrategy::Default.call "my_label", :method, ["Hello", :World, 1], "Hello World!"
      end.to output(/Putter Debugging: .*my_label -- Method: :method, Args: \["Hello", :World, 1\], Result: Hello World!/).to_stdout
    end
  end
end
