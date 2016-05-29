$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../support', __FILE__)

require "pry"
require "putter"
require "test_class"

module Putter
  module PrintStrategy
    Testing = Proc.new {}
    MethodTesting = Proc.new do |_, method, args|
      puts "Method: :#{method}, Args: #{args}"
    end
    ResultTesting = Proc.new do |result|
      puts "Result: #{result}"
    end
  end
end

RSpec.configure do |config|
  config.before(:each) do
    Putter.configure do |config|
      config.method_strategy = Putter::PrintStrategy::Testing
      config.print_results = false
    end
  end
end
