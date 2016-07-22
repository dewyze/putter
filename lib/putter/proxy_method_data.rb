module Putter
  class ProxyMethodData
    STACK_TRACE_IGNORE_REGEX = /(?!.*(\.rbenv|\.rvm|\/lib\/putter\/follower))(^.*$)/

    attr_accessor :label, :line, :method, :args, :result

    def initialize(params)
      @label = params[:label]
      @line = params[:line]
      @method = params[:method]
      @args = params[:args]
      @result = params[:result]
    end

    def stack_trace_ignore_regex
      STACK_TRACE_IGNORE_REGEX
    end
  end
end
