module Putter
  module MethodCreator
    def add_putter_instance_method_to_proxy(proxy, data)
      add_putter_method_to_proxy(proxy, data, :instance_exec)
    end

    def add_putter_class_method_to_proxy(proxy, data)
      add_putter_method_to_proxy(proxy, data, :module_exec)
    end

    private

    def add_putter_method_to_proxy(proxy, data, eval_method)
      proxy.send(eval_method, data) do |data|
        define_method(data.method) do |*proxy_args, &blk|
          line = caller.find {|call| call.match(data.stack_trace_ignore_regex)}
          data.line = line.split(::Dir.pwd)[1]
          data.args = proxy_args.to_s
          data.result = super *proxy_args, &blk
          ::Putter.configuration.print_strategy.call data
          data.result
        end
      end
    end
  end
end
