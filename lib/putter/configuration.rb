module Putter
  class Configuration
    attr_accessor :method_strategy, :print_results, :result_strategy
    attr_writer :ignore_methods_from

    def initialize
      @method_strategy = PrintStrategy::MethodStrategy
      @result_strategy = PrintStrategy::ResultStrategy
      @ignore_methods_from = [Object]
      @print_results = true
    end

    def ignore_methods_from
      if @ignore_methods_from.nil?
        []
      elsif !@ignore_methods_from.is_a?(Array)
        [@ignore_methods_from]
      else
        @ignore_methods_from
      end
    end
  end
end
