require "colorize"

module Putter
  module PrintStrategy
    Default = Proc.new do |obj, method, args|
      puts "\tPutter Debugging:  ".colorize(:cyan) + "#{obj.inspect}".colorize(:green)
      puts "\t-----------------".colorize(:cyan)
      puts "\t\t  Method:  ".colorize(:cyan) + ":#{method}".colorize(:green)
      puts "\t\t    Args:  ".colorize(:cyan) + "#{args}".colorize(:green)
      puts
    end
  end
end
