describe Putter::WatcherData do
  it "sets a label if provided" do
    data = Putter::WatcherData.new({ label: "my_label" }, nil)

    expect(data.label).to eq("my_label")
  end

  it "uses the class name if no label is provided" do
    data = Putter::WatcherData.new({}, Object)

    expect(data.label).to eq("Object")
  end

  it "sets the new method if no methods are passed" do
    data = Putter::WatcherData.new({}, Object)

    expect(data.proxy_methods).to contain_exactly(:new)
  end

  it "sets the methods if provided as an array" do
    data = Putter::WatcherData.new({ methods: [:test]}, Object)

    expect(data.proxy_methods).to include(:test)
  end

  it "sets a single method as an array" do
    data = Putter::WatcherData.new({ methods: :test}, Object)

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

  it "does not include ignored methods if no methods are passed in" do
    Putter.configuration.ignore_methods_from = [Object]
    expected_methods = [:new]
    unexpected_methods = Object.singleton_class.instance_methods - expected_methods
    data = Putter::WatcherData.new({}, Object)

    expect(data.proxy_methods & unexpected_methods).to be_empty
  end

  it "includes whitelist methods" do
    Putter.configuration.ignore_methods_from = [Object]
    Putter.configuration.methods_whitelist = [:to_s]
    data = Putter::WatcherData.new({}, Object)

    expect(data.proxy_methods).to include(:to_s)
  end
end
