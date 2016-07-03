module Putter
  module MethodCreator
    def add_putter_method_to_proxy(proxy, eval_method, data)
      proxy.send(eval_method, data) do |data|
        define_method(data.method) do |*proxy_args, &blk|
          line = caller.find {|call| call.match(data.stack_trace_ignore_regex)}
          line = line.split(::Dir.pwd)[1]
          args_string = proxy_args.to_s
          result = super *proxy_args, &blk
          ::Putter.configuration.print_strategy.call data.label, line, data.method, args_string, result
          result
        end
      end
    end
  end
end
