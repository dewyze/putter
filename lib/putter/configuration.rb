module Putter
  class Configuration
    attr_accessor :print_strategy, :allow_production
    attr_writer :ignore_methods_from, :methods_whitelist

    def initialize
      @ignore_methods_from = [Object]
      @ignore_methods_from << ActiveRecord::Base if defined?(ActiveRecord::Base)
      @print_strategy = PrintStrategy::Default
      @allow_production = false
      @methods_whitelist = []
    end

    def ignore_methods_from
      convert_to_array(@ignore_methods_from)
    end

    def methods_whitelist
      convert_to_array(@methods_whitelist)
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
