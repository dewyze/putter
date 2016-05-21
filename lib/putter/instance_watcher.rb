module Putter
  class InstanceWatcher
    attr_reader :proxy

    def initialize(obj)
      @object = obj
      @proxy = MethodProxy.new
      @object.singleton_class.send(:prepend, proxy)
    end

    def method_missing(method, *args, &blk)
      unless @proxy.instance_methods.include?(method)
        add_method(method)
      end

      if blk
        @object.send(method, *args, &blk)
      else
        @object.send(method, *args)
      end
    end

    def add_method(method)
      @proxy.instance_eval do
        define_method(method) do |*proxy_args, &blk|
          super *proxy_args, &blk
        end
      end
    end
  end
end
