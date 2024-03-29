RSpec.describe Putter::FollowerData do
  describe "#label" do
    it "sets a label if provided" do
      data = Putter::FollowerData.new(nil, nil, { label: "my_label" })

      expect(data.label).to eq("my_label")
    end

    it "uses the class name for classes if no label is provided" do
      data = Putter::FollowerData.new(Object, nil, {})

      expect(data.label).to eq("Object")
    end

    it "uses the instance name for instances if no label is provided" do
      data = Putter::FollowerData.new(Object.new, nil, {})

      expect(data.label).to eq("Object instance")
    end
  end

  describe "#add_method?" do
    it "returns true if the method is allowlisted" do
      proxy = ::Putter::MethodProxy.new
      Putter.configuration.ignore_methods_from = [Object]
      Putter.configuration.methods_allowlist = [:to_s]
      data = Putter::FollowerData.new(Object.new, proxy, {})

      expect(data.add_method?(:to_s)).to be true
    end

    it "returns false if the method is denylisted" do
      klass = Class.new { def fake_method; end }
      proxy = ::Putter::MethodProxy.new
      Putter.configuration.methods_denylist = [:to_s]
      data = Putter::FollowerData.new(klass, proxy, {})

      expect(data.add_method?(:to_s)).to be false
    end

    it "returns false if the method is ignored class method" do
      proxy = ::Putter::MethodProxy.new
      Putter.configuration.ignore_methods_from = [Object]
      data = Putter::FollowerData.new(Object.new, proxy, {})

      expect(data.add_method?(:to_s)).to be false
    end

    it "returns false if it is already on the proxy" do
      proxy = Module.new do
        def new_method
        end
      end

      data = Putter::FollowerData.new(Object.new, proxy, {})

      expect(data.add_method?(:new_method)).to be false
    end

    it "returns false if it is already on the proxy and allowlisted" do
      proxy = Module.new do
        def new_method
        end
      end

      Putter.configuration.methods_allowlist = [:new_method]
      data = Putter::FollowerData.new(Object.new, proxy, {})

      expect(data.add_method?(:new_method)).to be false
    end

    it "returns true if no method were specified" do
      proxy = ::Putter::MethodProxy.new
      data = Putter::FollowerData.new(Object.new, proxy, {})

      expect(data.add_method?(:new_method)).to be true
    end

    it "returns true if method is specified" do
      proxy = ::Putter::MethodProxy.new
      data = Putter::FollowerData.new(
        Object.new,
        proxy,
        { methods: [:new_method] },
      )

      expect(data.add_method?(:new_method)).to be true
    end

    it "returns true if method is specified and denylisted" do
      Putter.configuration.methods_denylist = [:new_method]
      proxy = ::Putter::MethodProxy.new
      data = Putter::FollowerData.new(
        Object.new,
        proxy,
        { methods: [:new_method] },
      )

      expect(data.add_method?(:new_method)).to be true
    end

    it "returns true if method is specified and in the ignored objects list" do
      klass = Class.new { def test_method; end }
      Putter.configuration.ignore_methods_from = [klass]
      proxy = ::Putter::MethodProxy.new
      data = Putter::FollowerData.new(
        Object.new,
        proxy,
        { methods: [:test_method] },
      )

      expect(data.add_method?(:test_method)).to be true
    end
  end
end
