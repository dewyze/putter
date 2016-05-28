module Putter
  class Configuration
    attr_accessor :method_strategy, :print_results, :result_strategy

    def initialize
      @method_strategy = PrintStrategy::MethodStrategy
      @result_strategy = PrintStrategy::ResultStrategy
      @print_results = true
    end
  end
end
