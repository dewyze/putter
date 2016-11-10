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
    it "returns true if the method is whitelisted" do
      proxy = ::Putter::MethodProxy.new
      Putter.configuration.ignore_methods_from = [Object]
      Putter.configuration.methods_whitelist = [:to_s]
      data = Putter::FollowerData.new(Object.new, proxy, {})

      expect(data.add_method?(:to_s)).to be true
    end

    it "returns false if the method is blacklisted" do
      klass = Class.new { def fake_method; end }
      proxy = ::Putter::MethodProxy.new
      Putter.configuration.methods_blacklist = [:to_s]
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

    it "returns false if it is already on the proxy and whitelisted" do
      proxy = Module.new do
        def new_method
        end
      end

      Putter.configuration.methods_whitelist = [:new_method]
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
  end
end
