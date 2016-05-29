require "colorize"

module Putter
  module PrintStrategy
    MethodStrategy = Proc.new do |label, method, args|
      puts
      puts "\tPutter Debugging:  ".colorize(:cyan) + "#{label}".colorize(:green)
      puts "\t-----------------".colorize(:cyan)
      puts "\t\t  Method:  ".colorize(:cyan) + ":#{method}".colorize(:green)
      puts "\t\t    Args:  ".colorize(:cyan) + "#{args}".colorize(:green)
    end

    ResultStrategy = Proc.new do |result|
      puts "\t\t  Result:  ".colorize(:cyan) + "#{result}".colorize(:green)
    end
  end
end
