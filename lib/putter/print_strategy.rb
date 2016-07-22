require "colorize"

module Putter
  module PrintStrategy
    Default = Proc.new do |data|
      prefix = "\tPutter Debugging: #{data.label} ".colorize(:cyan)
      line = !data.line.nil? ? ".#{data.line} " : " "
      suffix = "-- Method: :#{data.method}, Args: #{data.args}, Result: #{data.result}".colorize(:green)
      puts prefix + line + suffix
    end
  end
end
