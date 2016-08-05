describe Putter::WatcherData do
  it "sets a label if provided" do
    data = Putter::WatcherData.new({ label: "my_label" }, "Class")

    expect(data.label).to eq("my_label")
  end

  it "uses the class name" do
    data = Putter::WatcherData.new({}, Object)

    expect(data.label).to eq("Object")
  end
end
