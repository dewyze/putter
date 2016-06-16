require "colorize"

module Putter
  module PrintStrategy
    Default = Proc.new do |label, line, method, args, result|
      prefix = "\tPutter Debugging: #{label} ".colorize(:cyan)
      line = !line.nil? ? ".#{line} " : " "
      suffix = "-- Method: :#{method}, Args: #{args}, Result: #{result}".colorize(:green)
      puts prefix + line + suffix
    end
  end
end
