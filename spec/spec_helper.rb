$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../support', __FILE__)

require "pry"
require "putter"
require "test_class"

def stub_test_instance_methods(test)
  allow(test).to receive(:test_instance_method)
  allow(test).to receive(:test_instance_method_arg)
  allow(test).to receive(:test_instance_method_block)
end
