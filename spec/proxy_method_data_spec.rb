describe Putter::ProxyMethodData do
  before(:each) do
    @data = Putter::ProxyMethodData.new({ label: "my label", method: :test_method })
  end

  it "holds the method and label" do
    expect(@data.method).to eq(:test_method)
    expect(@data.label).to eq("my label")
  end

  context "stack trace regex" do
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
