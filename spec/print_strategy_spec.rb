RSpec.describe Putter::PrintStrategy do
  describe Putter::PrintStrategy::Default do
    it "prints the output" do
      expect do
        Putter::PrintStrategy::Default.call "my_label", "line number:23", :method, ["Hello", :World, 1], "Hello World!"
      end.to output(/Putter Debugging: my_label .*line number:23.* -- Method: :method, Args: \["Hello", :World, 1\], Result: Hello World!/).to_stdout
    end
  end
end
