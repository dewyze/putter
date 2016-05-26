$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../support', __FILE__)

require "pry"
require "putter"
require "test_class"

def stub_methods(obj)
  allow(obj).to receive(:test_method)
  allow(obj).to receive(:test_method_arg)
  allow(obj).to receive(:test_method_block)
  allow(obj).to receive(:test_method_block_arg)
end
