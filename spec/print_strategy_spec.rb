RSpec.describe Putter::PrintStrategy do
  describe Putter::PrintStrategy::Default do
    it "outputs the header" do
      expect do
        Putter::PrintStrategy::Default.call
      end.to output(/\tPutter Debugging:/).to_stdout
    end

    it "outputs the object class name with instance" do
      test = Test.new

      expect do
        Putter::PrintStrategy::Default.call test
      end.to output(/Test instance/).to_stdout
    end

    it "outputs the object class name" do
      expect do
        Putter::PrintStrategy::Default.call Test
      end.to output(/Test/).to_stdout
    end

    it "outputs the '---' break" do
      expect do
        Putter::PrintStrategy::Default.call
      end.to output(/-----------------/).to_stdout
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

  describe "object_name" do
    it "returns the correct value for classes" do
      expect(Putter::PrintStrategy.object_name(Test)).to eq("Test")
    end

    it "returns the correct value for instances" do
      expect(Putter::PrintStrategy.object_name(Test.new)).to eq("Test instance")
    end
  end
end