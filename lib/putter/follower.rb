module Putter
  class Follower < BasicObject
    attr_reader :object, :proxied_methods, :proxy

    def initialize(obj, options={})
      @object = obj
      @proxy = MethodProxy.new
      @label = _object_label
      @object.singleton_class.send(:prepend, proxy)
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
      @proxy.instance_exec(@label) do |label|
        define_method(method) do |*proxy_args, &blk|
          ::Putter.configuration.method_strategy.call label, method, proxy_args
          super *proxy_args, &blk
        end
      end
    end

    def _add_method?(method)
      return (@proxy_all_methods || proxied_methods.include?(method.to_s)) &&
              !@proxy.instance_methods.include?(method)
    end

    def _object_label
      if @object.class == ::Class
        @object.name
      else
        @object.class.name + " instance"
      end
    end
  end
end
