module Putter
  class Configuration
    attr_accessor :method_strategy, :print_results, :result_strategy
    attr_writer :ignore_methods_from, :methods_whitelist

    def initialize
      @ignore_methods_from = [Object]
      @method_strategy = PrintStrategy::MethodStrategy
      @methods_whitelist = []
      @result_strategy = PrintStrategy::ResultStrategy
      @print_results = true
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
