module Putter
  class Configuration
    attr_accessor :allow_production, :methods_whitelist, :methods_blacklist, :print_strategy
    attr_writer :ignore_methods_from

    def initialize
      @ignore_methods_from = [Object]
      @ignore_methods_from << ActiveRecord::Base if defined?(ActiveRecord::Base)
      @print_strategy = PrintStrategy::Default
      @allow_production = false
      @methods_whitelist = []
      @methods_blacklist = []
    end

    def ignore_methods_from
      convert_to_array(@ignore_methods_from)
    end

    def methods_whitelist=(methods)
      raise ::Putter::MethodConflictError unless (@methods_blacklist & methods).empty?

      @methods_whitelist = methods
    end

    def methods_blacklist=(methods)
      raise ::Putter::MethodConflictError unless (@methods_whitelist & methods).empty?

      @methods_blacklist = methods
    end

    private

    def convert_to_array(val)
      if val.nil?
        []
      elsif !val.is_a?(Array)
        [val]
      else
        val
      end
    end
  end
end
