describe Putter do
  it 'has a version number' do
    expect(Putter::VERSION).not_to be nil
  end

  describe "#follow" do
    context "instances" do
      it "creates a follower for the object" do
        test = Test.new
        follower = Putter.follow(test)

        expect(follower.object).to eq(test)
      end

      it "creates a method proxy" do
        test = Test.new
        follower = Putter.follow(test)

        expect(test.singleton_class.ancestors.first).to be_an_instance_of(Putter::MethodProxy)
      end
    end

    context "classes" do
      before(:each) do
        @class = Class.new
      end

      it "creates a follower for the object" do
        follower = Putter.follow(@class)

        expect(follower.object).to eq(@class)
      end

      it "creates a method proxy" do
        follower = Putter.follow(@class)

        expect(@class.singleton_class.ancestors.first).to be_an_instance_of(Putter::MethodProxy)
      end
    end
  end
end
