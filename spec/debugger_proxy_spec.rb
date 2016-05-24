describe Putter::DebuggerProxy do
  it "uses 'Putter::InstanceDebugger' for instances of classes" do
    test = Test.new
    klass = Putter::DebuggerProxy.get_debugger(test)

    expect(klass).to eq(Putter::InstanceDebugger)
  end
end
