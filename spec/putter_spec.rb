describe Putter do
  it 'has a version number' do
    expect(Putter::VERSION).not_to be nil
  end

  describe "#debug" do
    context "instances" do
      it "creates a watcher for the object" do
        test = TestClass.new
        watcher = Putter.debug(test)

        expect(watcher.object).to eq(test)
      end

      it "creates a method proxy" do
        test = TestClass.new
        watcher = Putter.debug(test)

        expect(test.singleton_class.ancestors.first).to be_an_instance_of(Putter::MethodProxy)
      end
    end
  end
end
