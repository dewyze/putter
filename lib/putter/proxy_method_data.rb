module Putter
  class ProxyMethodData
    STACK_TRACE_IGNORE_REGEX = /(?!.*(\.rbenv|\.rvm|\/lib\/putter\/follower))(^.*$)/

    attr_reader :method, :label

    def initialize(method, label)
      @method = method
      @label = label
    end

    def stack_trace_ignore_regex
      STACK_TRACE_IGNORE_REGEX
    end
  end
end
