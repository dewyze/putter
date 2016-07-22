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

  it "does not log methods from configuration.ignore_methods_from" do
    set_testing_print_strategy
    Putter.configuration.ignore_methods_from = [Object]
    Putter::Watcher.watch(subject)

    expect{subject.to_s}.to_not output.to_stdout
  end

  it "does log methods if configuration.ignore_methods_from is empty" do
    Putter.configuration.print_strategy = Proc.new do |data|
      puts "Method: :#{data.method}"
    end

    Putter.configuration.ignore_methods_from = []
    Putter::Watcher.watch(subject)

    expect{subject.to_s}.to output("Method: :to_s\n").to_stdout
  end

  it "does log methods in the methods whitelist" do
    Putter.configuration.print_strategy = Proc.new do |data|
      puts "Method: :#{data.method}"
    end

    Putter.configuration.methods_whitelist = [:to_s]
    Putter::Watcher.watch(subject)

    expect{subject.to_s}.to output("Method: :to_s\n").to_stdout
  end

  it "logs the 'new' method" do
    Putter.configuration.print_strategy = Proc.new do |data|
      puts "Method: :#{data.method}, Args: #{data.args}"
    end

    Putter::Watcher.watch(subject)

    expect{subject.new}.to output("Method: :new, Args: []\n").to_stdout
  end

  it "adds methods to the proxy" do
    Putter.configuration.print_strategy = Proc.new do |data|
      puts "Method: :#{data.method}, Args: #{data.args}"
    end
    Putter::Watcher.watch(subject)

    expect(subject.ancestors[0].methods).to include(:test_class_method, :test_class_method_arg)
  end

  it "does not call other watched classes" do
    kls = Class.new
    Putter::Watcher.watch(subject)
    Putter::Watcher.watch(kls)

    expect do
      kls.test_class_method
    end.to_not raise_error(/super: no superclass method `test_class_method'/)
  end

  it "prints the class name as the label if it is not set" do
    class ClassName
      def self.test_method
        "test_method"
      end
    end

    Putter.configuration.print_strategy = Proc.new do |data|
      puts "Label: #{data.label}"
    end

    Putter::Watcher.watch(ClassName)

    expect do
      ClassName.test_method
    end.to output("Label: ClassName\n").to_stdout
  end

  it "prints the label if it is passed in" do
    Putter.configuration.print_strategy = Proc.new do |data|
      puts "Label: #{data.label}"
    end

    Putter::Watcher.watch(subject, { label: "my label" })

    expect do
      subject.test_class_method
    end.to output("Label: my label\n").to_stdout
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
