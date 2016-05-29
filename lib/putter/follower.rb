module Putter
  class Follower < BasicObject
    attr_reader :object, :proxied_methods, :proxy

    def initialize(obj, options={})
      @object = obj
      @proxy = MethodProxy.new
      @object.singleton_class.send(:prepend, proxy)
      _set_options(options)
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
      @proxy.instance_exec(@label, _print_results?) do |label, print_results|
        define_method(method) do |*proxy_args, &blk|
          ::Putter.configuration.method_strategy.call label, method, proxy_args
          result = super *proxy_args, &blk
          ::Putter.configuration.result_strategy.call result if print_results
          result
        end
      end
    end

    def _add_method?(method)
      return (@proxy_all_methods || proxied_methods.include?(method.to_s)) &&
              !@proxy.instance_methods.include?(method)
    end

    def _set_label(label)
      if !label.nil?
        @label = label
      elsif @object.class == ::Class
        @label = @object.name
      else
        @label = @object.class.name + " instance"
      end
    end

    def _print_results?
      ::Putter.configuration.print_results
    end

    def _set_methods(methods)
      if methods.nil?
        @proxy_all_methods = true
      else
        @proxied_methods = methods.map(&:to_s)
        @proxy_all_methods = false
      end
    end

    def _set_options(options)
      _set_label(options[:label])
      _set_methods(options[:methods])
    end
  end
end
