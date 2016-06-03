require "colorize"

module Putter
  module PrintStrategy
    MethodStrategy = Proc.new do |label, method, args|
      prefix = "\tPutter Debugging: ".colorize(:cyan)
      suffix = "#{label} -- Method: :#{method}, Args: #{args}".colorize(:green)
      puts prefix + suffix
    end

    ResultStrategy = Proc.new do |result|
      puts "\t          Result: ".colorize(:cyan) + "#{result}".colorize(:green)
    end
  end
end
