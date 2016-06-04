require "colorize"

module Putter
  module PrintStrategy
    Default = Proc.new do |label, method, args, result|
      prefix = "\tPutter Debugging: ".colorize(:cyan)
      suffix = "#{label} -- Method: :#{method}, Args: #{args}, Result: #{result}".colorize(:green)
      puts prefix + suffix
    end
  end
end
