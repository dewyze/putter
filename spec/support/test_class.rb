class Test
  attr_reader :name

  def initialize(name="Putter")
    @name = name
  end

  def test_method
    "Hello World!"
  end

  def test_method_arg(arg)
    "Hello #{arg}!"
  end

  def test_method_block(&blk)
    yield
  end

  def test_method_block_arg(&blk)
    yield "World"
  end
end
