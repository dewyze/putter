describe Putter::ProxyMethodData do
  it "holds the method and label" do
    data = Putter::ProxyMethodData.new(:test_method, "my label")

    expect(data.method).to eq(:test_method)
    expect(data.label).to eq("my label")
  end

  context "stack trace regex" do
    before(:each) do
      @data = Putter::ProxyMethodData.new(:test_method, "my label")
    end

    it "rejects rvm stack traces" do
      expect(".rvm").to_not match(@data.stack_trace_ignore_regex)
    end

    it "rejects rbenv stack traces" do
      expect(".rbenv").to_not match(@data.stack_trace_ignore_regex)
    end

    it "rejects putter stack traces" do
      expect("putter/lib/putter/follower").to_not match(@data.stack_trace_ignore_regex)
    end
  end
end
