describe Putter::WatcherData do
  describe "#label" do
    it "sets a label if provided" do
      data = Putter::WatcherData.new({ label: "my_label" }, nil)

      expect(data.label).to eq("my_label")
    end

    it "uses the class name if no label is provided" do
      data = Putter::WatcherData.new({}, Object)

      expect(data.label).to eq("Object")
    end
  end

  describe "#proxy_methods" do
    it "sets the new method if no methods are passed" do
      data = Putter::WatcherData.new({}, Object)

      expect(data.proxy_methods).to contain_exactly(:new)
    end

    it "sets the methods if provided as an array" do
      data = Putter::WatcherData.new({methods: [:test]}, Object)

      expect(data.proxy_methods).to include(:test)
    end

    it "sets a single method as an array" do
      data = Putter::WatcherData.new({methods: :test}, Object)

      expect(data.proxy_methods).to include(:test)
    end

    it "includes class methods" do
      klass = Class.new do
        def self.test_method
          "test"
        end
      end

      data = Putter::WatcherData.new({}, klass)

      expect(data.proxy_methods).to include(:test_method)
    end

    it "does not include ignored method classes" do
      ignored_klass = Class.new { def self.fake_class_method; end }
      klass = Class.new(ignored_klass)

      Putter.configuration.ignore_methods_from = [ignored_klass]

      data = Putter::WatcherData.new({}, klass)

      expect(data.proxy_methods).to contain_exactly(:new)
    end

    it "includes whitelist methods" do
      Putter.configuration.ignore_methods_from = [Object]
      Putter.configuration.methods_whitelist = [:to_s]

      data = Putter::WatcherData.new({}, Object)

      expect(data.proxy_methods).to include(:to_s)
    end
  end
end
