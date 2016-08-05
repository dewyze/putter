describe Putter::WatcherData do
  it "sets a label if provided" do
    data = Putter::WatcherData.new({ label: "my_label" }, nil)

    expect(data.label).to eq("my_label")
  end

  it "uses the class name" do
    data = Putter::WatcherData.new({}, Object)

    expect(data.label).to eq("Object")
  end

  it "sets the methods if provided" do
    data = Putter::WatcherData.new({ methods: [:test]}, Object)

    expect(data.methods).to contain_exactly(:test)
  end

  it "sets a single method as an array" do
    data = Putter::WatcherData.new({ methods: :test}, Object)

    expect(data.methods).to contain_exactly(:test)
  end

  it "sets an empty array if no methods are provided" do
    data = Putter::WatcherData.new({}, Object)

    expect(data.methods).to eq([])
  end
end
