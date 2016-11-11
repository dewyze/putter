require "colorize"

module Putter
  module PrintStrategy
    Default = Proc.new do |data|
      prefix = "\tPutter Debugging: #{data.label} ".colorize(:cyan)
      if data.line.nil?
        line = " "
      elsif data.line[0] != "/"
        line = "./#{data.line} "
      else
        line = ".#{data.line} "
      end
      suffix = "-- Method: :#{data.method}, Args: #{data.args}, Result: #{data.result}".colorize(:green)
      puts prefix + line + suffix
    end
  end
end
