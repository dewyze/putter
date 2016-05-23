describe Putter::WatcherProxy do
  it "uses 'Putter::InstanceWatcher' for instances of classes" do
    test = TestClass.new
    klass = Putter::WatcherProxy.get_watcher(test)

    expect(klass).to eq(Putter::InstanceWatcher)
  end
end
