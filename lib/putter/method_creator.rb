module Putter
  module MethodCreator
    def add_putter_method_to_proxy(proxy, data)
      proxy.send(:instance_exec, data) do |data|
        define_method(data.method) do |*proxy_args, &blk|
          data.line = caller.find {|call| call.match(data.stack_trace_ignore_regex)}
          if data.line.include?(::Dir.pwd)
            data.line = data.line.split(::Dir.pwd)[1]
          end
          data.args = proxy_args.to_s
          data.result = super *proxy_args, &blk
          ::Putter.configuration.print_strategy.call data
          data.result
        end
      end
    end
  end
end
