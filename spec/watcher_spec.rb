describe Putter::Watcher do
  subject do
    Class.new do
      def self.test_class_method
        "class method"
      end

      def self.test_class_method_arg(arg)
        "class method: #{arg}"
      end

      def test_method
        "instance method"
      end
    end
  end

  it "prepends a proxy" do
    Putter::Watcher.watch(subject)

    expect(subject.singleton_class.ancestors[0]).to be_a(Putter::MethodProxy)
  end

  it "adds methods to the proxy from the watcher data" do
    methods = [:test_method_1, :test_method_2]
    data = Putter::WatcherData.new({methods: methods}, subject)

    Putter::Watcher.registry[subject.singleton_class] = data
    proxy = Putter::Watcher.class_proxy(subject.singleton_class)

    expect(proxy.instance_methods).to contain_exactly(:test_method_1, :test_method_2)
  end

  it "does not call other watched classes" do
    kls = Class.new
    Putter::Watcher.watch(subject)
    Putter::Watcher.watch(kls)

    expect do
      kls.test_class_method
    end.to_not raise_error(/super: no superclass method `test_class_method'/)
  end

  it "prints the line without the directory with number" do
    Putter.configuration.print_strategy = Proc.new do |data|
      puts "Line: .#{data.line}"
    end

    Putter::Watcher.watch(subject)

    file = __FILE__
    file = file.split(::Dir.pwd)[1]
    expected_line = __LINE__
    expect do
      subject.test_class_method
    end.to output(/Line: \.#{file}:#{expected_line + 2}:in `block/).to_stdout
  end

  it "prints the method and args using the configured strategy" do
    Putter.configuration.print_strategy = Proc.new do |data|
      puts "Method: :#{data.method}, Args: #{data.args}"
    end

    Putter::Watcher.watch(subject)

    expect do
      subject.test_class_method_arg("world")
    end.to output("Method: :test_class_method_arg, Args: [\"world\"]\n").to_stdout
  end

  it "prints the method and args using the configured strategy" do
    Putter.configuration.print_strategy = Proc.new do |data|
      puts "Result: #{data.result}"
    end

    Putter::Watcher.watch(subject)

    expect do
      subject.test_class_method
    end.to output("Result: class method\n").to_stdout
  end

  it "follows created instances" do
    Putter::Watcher.watch(subject)
    [subject.new, subject.new].each do |instance|
      expect(instance.singleton_class.ancestors[0]).to be_a(Putter::MethodProxy)
    end
  end
end
