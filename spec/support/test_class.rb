class Test
  attr_reader :name

  def initialize(name="Putter")
    @name = name
  end

  def test_method
    puts "test_instance_method"
  end

  def test_method_arg(arg)
    puts "test_instance_method_arg: #{arg}"
  end

  def test_method_block(&blk)
    yield
  end

  def test_method_block_arg(&blk)
    yield "World"
  end
end
