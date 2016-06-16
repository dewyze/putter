RSpec.describe Putter::PrintStrategy do
  describe Putter::PrintStrategy::Default do
    it "prints the output" do
      expect do
        Putter::PrintStrategy::Default.call "my_label", "/spec/print_strategy_spec.rb:5", :method, ["Hello", :World, 1], "Hello World!"
      end.to output(/Putter Debugging: my_label .*\.\/spec\/print_strategy_spec\.rb:5 .*-- Method: :method, Args: \["Hello", :World, 1\], Result: Hello World!/).to_stdout
    end

    it "works with empty lines" do
      expect do
        Putter::PrintStrategy::Default.call "my_label", nil, :method, ["Hello", :World, 1], "Hello World!"
      end.to output(/Putter Debugging: my_label .*-- Method: :method, Args: \["Hello", :World, 1\], Result: Hello World!/).to_stdout
    end
  end
end
