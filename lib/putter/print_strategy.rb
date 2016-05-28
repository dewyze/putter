require "colorize"

module Putter
  module PrintStrategy
    MethodStrategy = Proc.new do |obj, method, args|
      puts "\tPutter Debugging:  ".colorize(:cyan) + "#{object_name(obj)}".colorize(:green)
      puts "\t-----------------".colorize(:cyan)
      puts "\t\t  Method:  ".colorize(:cyan) + ":#{method}".colorize(:green)
      puts "\t\t    Args:  ".colorize(:cyan) + "#{args}".colorize(:green)
      puts
    end

    ResultStrategy = Proc.new do |result|
      puts "\t\t  Result:  ".colorize(:cyan) + "#{result}".colorize(:green)
    end

    def self.object_name(obj)
      if obj.class == Class
        obj.name
      else
        obj.class.name + " instance"
      end
    end
  end
end
