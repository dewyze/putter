module Putter
  class Follower < BasicObject
    attr_reader :object, :proxied_methods, :proxy

    def initialize(obj, options={})
      @object = obj
      @proxy = MethodProxy.new
      @object.singleton_class.send(:prepend, proxy)
      @strategy = options.fetch(:strategy, PrintStrategy::Default)

      if options.has_key?(:methods)
        @proxied_methods = options[:methods].map(&:to_s)
        @proxy_all_methods = false
      else
        @proxy_all_methods = true
      end
    end

    def method_missing(method, *args, &blk)
      if _add_method?(method)
        add_method(method)
      end

      if blk
        @object.send(method, *args, &blk)
      else
        @object.send(method, *args)
      end
    end

    def add_method(method)
      log_method(method, &@strategy)
    end

    def log_method(method, &strategy)
      @proxy.instance_eval do
        define_method(method) do |*proxy_args, &blk|
          strategy.call self, method, proxy_args if strategy
          super *proxy_args, &blk
        end
      end
    end

    def _add_method?(method)
      return (@proxy_all_methods || proxied_methods.include?(method.to_s)) &&
              !@proxy.instance_methods.include?(method)
    end
  end
end
