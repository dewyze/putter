module Putter
  class Configuration
    attr_accessor :allow_production, :methods_allowlist, :methods_denylist, :print_strategy
    attr_writer :ignore_methods_from

    alias_method :methods_whitelist=, :methods_allowlist=
    alias_method :methods_blacklist=, :methods_denylist=

    def initialize
      @ignore_methods_from = [Object]
      @ignore_methods_from << ActiveRecord::Base if defined?(ActiveRecord::Base)
      @print_strategy = PrintStrategy::Default
      @allow_production = false
      @methods_allowlist = []
      @methods_denylist = []
    end

    def ignore_methods_from
      convert_to_array(@ignore_methods_from)
    end

    def methods_allowlist=(methods)
      raise ::Putter::MethodConflictError unless (@methods_denylist & methods).empty?

      @methods_allowlist = methods
    end

    def methods_denylist=(methods)
      raise ::Putter::MethodConflictError unless (@methods_allowlist & methods).empty?

      @methods_denylist = methods
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
