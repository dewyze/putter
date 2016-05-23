class Test
  attr_reader :name

  def initialize(name="Putter")
    @name = name
  end

  def test_instance_method
    puts "test_instance_method"
  end

  def test_instance_method_arg(arg)
    puts "test_instance_method_arg: #{arg}"
  end

  def test_instance_method_block(&blk)
    yield
  end

  def test_instance_method_block_arg(&blk)
    yield "World"
  end
end

class TestClass
  def self.test_class_method
    puts "test_class_method"
  end

  def self.test_class_method_arg(arg)
    puts "test_class_method_arg: #{arg}"
  end

  def self.test_class_method_block(&blk)
    yield
  end

  def self.test_class_method_block_arg(&blk)
    yield "World"
  end
end
