$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../support', __FILE__)

require "pry"
require "putter"
require "test_class"

module Putter
  module PrintStrategy
    Silent = Proc.new {}
    MethodTesting = Proc.new do |_, method, args|
      "Method: :#{method}, Args: #{args}"
    end
    ResultTesting = Proc.new do |result|
      "Result: #{result}"
    end
  end
end

RSpec.configure do |config|
  config.before(:each) do
    ::Putter.reset_configuration
    Putter.configure do |config|
      config.method_strategy = Putter::PrintStrategy::Silent
      config.result_strategy = Putter::PrintStrategy::Silent
      config.print_results = false
    end
  end
end

def get_follower(obj)
  follower = Putter::Follower.new(obj)
end
