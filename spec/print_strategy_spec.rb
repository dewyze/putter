RSpec.describe Putter::PrintStrategy do
  describe Putter::PrintStrategy::Default do
    it "outputs the header" do
      expect do
        Putter::PrintStrategy::Default.call
      end.to output(/\tPutter Debugging:/).to_stdout
    end

    it "outputs the object inspected" do
      test = Test.new

      expect do
        Putter::PrintStrategy::Default.call test
      end.to output(/#{test.inspect}/).to_stdout
    end

    it "outputs the '---' break" do
      expect do
        Putter::PrintStrategy::Default.call
      end.to output(/-----------------/).to_stdout
    end

    it "outputs the line title" do
      expect do
        Putter::PrintStrategy::Default.call
      end.to output(/\t\t    Line:  /).to_stdout
    end

    xit "outputs the line title" do
      pending "This needs to be tested"
    end

    it "outputs the method title" do
      expect do
        Putter::PrintStrategy::Default.call
      end.to output(/\t\t  Method:  /).to_stdout
    end

    it "outputs the method" do
      expect do
        Putter::PrintStrategy::Default.call nil, :method
      end.to output(/:method/).to_stdout
    end

    it "outputs the Args title" do
      expect do
        Putter::PrintStrategy::Default.call
      end.to output(/\t\t    Args:  /).to_stdout
    end

    it "outputs the args as an array" do
      expect do
        Putter::PrintStrategy::Default.call nil, :method, ["Hello", :World, 1]
      end.to output(/\["Hello", :World, 1\]/).to_stdout
    end
  end
end
