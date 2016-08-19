describe Putter::MethodCreator do
  let(:proxy) { Putter::MethodProxy.new }
  let(:data) do
     Putter::ProxyMethodData.new({
       label: "My label",
       method: :test_method,
     })
  end
  let(:implementer) do
    klass = Class.new do
      include Putter::MethodCreator
    end

    klass.new
  end

  before(:each) do
    implementer.add_putter_instance_method_to_proxy(proxy, data)
  end

  context "add_putter_instance_method_to_proxy" do
    let(:subject) do
      klass = Class.new do
        def test_method(arg="World")
          "Hello #{arg}"
        end
      end

      klass.send(:prepend, proxy)
      klass.new
    end

    it "adds the method to the proxy" do
      expect(proxy.instance_methods).to include(:test_method)
    end

    it "adds the line to the data" do
      subject.test_method
      expected_line = __LINE__ - 1
      file = __FILE__.split(::Dir.pwd)[1]

      expect(data.line).to match(/^#{file}:#{expected_line}/)
    end

    it "adds the args to the data" do
      args = ["my_arg"]
      subject.test_method(*args)

      expect(data.args).to eq(args.to_s)
    end

    it "adds the result to the data" do
      subject.test_method

      expect(data.result).to eq("Hello World")
    end

    it "returns the result of the super method" do
      expect(subject.test_method).to eq("Hello World")
    end

    it "prints with the configured print strategy" do
      ::Putter.configuration.print_strategy = Proc.new do |data|
        puts "Line: #{data.line}, Method: :#{data.method}, Args: #{data.args}, Result: \"#{data.result}\""
      end

      file = __FILE__.split(::Dir.pwd)[1]
      expected_line = __LINE__ + 2
      expect do
        subject.test_method("my_arg")
      end.to output(/Line: #{file}:#{expected_line}.*, Method: :test_method, Args: \["my_arg"\], Result: "Hello my_arg"/).to_stdout
    end
  end

  context "#add_putter_class_method_to_proxy" do
    let(:subject) do
      klass = Class.new do
        def self.test_method(arg="World")
          "Hello #{arg}"
        end
      end

      klass.singleton_class.send(:prepend, proxy)
      klass
    end

    it "adds the method to the proxy" do
      expect(proxy.instance_methods).to include(:test_method)
    end

    it "adds the line to the data" do
      subject.test_method
      expected_line = __LINE__ - 1
      file = __FILE__.split(::Dir.pwd)[1]

      expect(data.line).to match(/^#{file}:#{expected_line}/)
    end

    it "adds the args to the data" do
      args = ["my_arg"]
      subject.test_method(*args)

      expect(data.args).to eq(args.to_s)
    end

    it "adds the result to the data" do
      subject.test_method

      expect(data.result).to eq("Hello World")
    end

    it "returns the result of the super method" do
      expect(subject.test_method).to eq("Hello World")
    end

    it "prints with the configured print strategy" do
      ::Putter.configuration.print_strategy = Proc.new do |data|
        puts "Line: #{data.line}, Method: :#{data.method}, Args: #{data.args}, Result: \"#{data.result}\""
      end

      file = __FILE__.split(::Dir.pwd)[1]
      expected_line = __LINE__ + 2
      expect do
        subject.test_method("my_arg")
      end.to output(/Line: #{file}:#{expected_line}.*, Method: :test_method, Args: \["my_arg"\], Result: "Hello my_arg"/).to_stdout
    end
  end
end
