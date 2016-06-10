$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../support', __FILE__)

require "pry"
require "putter"
require "test_class"

module Putter
  module PrintStrategy
    Silent = Proc.new {}
    Testing = Proc.new do |_, line, method, args, result|
      puts "Method: :#{method}, Args: #{args}, Result: #{result}"
    end
  end
end

RSpec.configure do |config|
  config.before(:each) do
    ::Putter.reset_configuration
    Putter.configure do |config|
      config.print_strategy = Putter::PrintStrategy::Silent
    end
  end
end

def get_follower(obj)
  follower = Putter::Follower.new(obj)
end
