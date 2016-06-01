module Putter
  class Configuration
    attr_accessor :ignore_methods_from, :method_strategy, :print_results, :result_strategy

    def initialize
      @method_strategy = PrintStrategy::MethodStrategy
      @result_strategy = PrintStrategy::ResultStrategy
      @ignore_methods_from = [Object]
      @print_results = true
    end
  end
end
