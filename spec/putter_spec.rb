describe Putter do
  it 'has a version number' do
    expect(Putter::VERSION).not_to be nil
  end

  describe "#debug" do
    context "instances" do
      it "creates a debugger for the object" do
        test = TestClass.new
        debugger = Putter.debug(test)

        expect(debugger.object).to eq(test)
      end

      it "creates a method proxy" do
        test = TestClass.new
        debugger = Putter.debug(test)

        expect(test.singleton_class.ancestors.first).to be_an_instance_of(Putter::MethodProxy)
      end
    end
  end
end
