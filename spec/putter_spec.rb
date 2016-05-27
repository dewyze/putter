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

      it "accepts specific methods" do
        test = Test.new
        follower = Putter.follow(test, methods: [:test_method_arg])

        expect do
          follower.test_method_arg("World")
        end.to output(/Method:.*:test_method_arg.*\n.*Args:.*\["World"\]/).to_stdout
      end

      it "ignores unspecified methods" do
        test = Test.new
        follower = Putter.follow(test, methods: [:test_method])

        expect do
          follower.test_method_arg("World")
        end.to_not output(/:test_method_args\n.*World/).to_stdout
      end

      it "prints debugging info for method calls" do
        test = Test.new
        follower = Putter.follow(test)

        expect do
          follower.test_method
        end.to output(/Method:.*:test_method/).to_stdout

        expect do
          follower.test_method_arg("World")
        end.to output(/:test_method_arg.*\n.*World/).to_stdout
      end
    end

    context "classes" do
      before(:each) do
        @class = Class.new do
          def self.test_method
          end

          def self.test_method_arg(arg)
          end
        end
      end

      it "creates a follower for the object" do
        follower = Putter.follow(@class)

        expect(follower.object).to eq(@class)
      end

      it "creates a method proxy" do
        follower = Putter.follow(@class)

        expect(@class.singleton_class.ancestors.first).to be_an_instance_of(Putter::MethodProxy)
      end

      it "accepts specific methods" do
        follower = Putter.follow(@class, methods: [:test_method_arg])

        expect do
          follower.test_method_arg("World")
        end.to output(/Method:.*:test_method_arg.*\n.*Args:.*\["World"\]/).to_stdout
      end

      it "ignores unspecified methods" do
        follower = Putter.follow(@class, methods: [:test_method])

        expect do
          follower.test_method_arg("World")
        end.to_not output(/:test_method_args\n.*World/).to_stdout
      end

      it "prints debugging info for method calls" do
        follower = Putter.follow(@class)

        expect do
          follower.test_method
        end.to output(/Method:.*:test_method/).to_stdout

        expect do
          follower.test_method_arg("World")
        end.to output(/:test_method_arg.*\n.*World/).to_stdout
      end
    end
  end
end
