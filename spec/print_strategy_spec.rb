RSpec.describe Putter::PrintStrategy do
  describe Putter::PrintStrategy::Default do
    it "prints the output" do
      data = Putter::ProxyMethodData.new({
        label: "my_label",
        line: "/spec/print_strategy_spec.rb:5",
        method: :method,
        args: ["Hello", :World, 1],
        result: "Hello World!",
      })

      expect do
        Putter::PrintStrategy::Default.call data
      end.to output(/Putter Debugging: my_label .*\.\/spec\/print_strategy_spec\.rb:5 .*-- Method: :method, Args: \["Hello", :World, 1\], Result: Hello World!/).to_stdout
    end

    it "does not print a dot if there is no line number" do
      data = Putter::ProxyMethodData.new({
        label: "my_label",
        method: :method,
        args: ["Hello", :World, 1],
        result: "Hello World!",
      })

      expect do
        Putter::PrintStrategy::Default.call data
      end.to output(/Putter Debugging: my_label .*-- Method: :method, Args: \["Hello", :World, 1\], Result: Hello World!/).to_stdout
    end
  end
end
