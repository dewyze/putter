module Putter
  class Configuration
    attr_accessor :print_strategy
    attr_writer :ignore_methods_from, :methods_whitelist

    def initialize
      @ignore_methods_from = [Object]
      @ignore_methods_from << ActiveRecord::Base if defined?(ActiveRecord::Base)
      @print_strategy = PrintStrategy::Default
      @methods_whitelist = []
    end

    def ignore_methods_from
      _convert_to_array(@ignore_methods_from)
    end

    def methods_whitelist
      _convert_to_array(@methods_whitelist)
    end

    def _convert_to_array(val)
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
