module Putter
  class Follower < BasicObject
    attr_reader :object, :proxied_methods, :proxy

    def initialize(obj, options={})
      @object = obj
      @proxy = MethodProxy.new
      begin
        @object.singleton_class.send(:prepend, proxy)
      rescue ::NoMethodError
        ::Kernel.raise ::Putter::BasicObjectError
      end
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
      data = ProxyMethodData.new(method, @label)

      @proxy.instance_exec(data) do |data|
        define_method(data.method) do |*proxy_args, &blk|
          line = caller.find {|call| call.match(data.stack_trace_ignore_regex)}
          line = line.split(::Dir.pwd)[1]
          args_string = proxy_args.to_s
          result = super *proxy_args, &blk
          ::Putter.configuration.print_strategy.call data.label, line, method, args_string, result
          result
        end
      end
    end

    def _add_method?(method)
      return true if _is_whitelisted_method?(method)
      return false if _is_ignored_method?(method)
      return false if @proxy.instance_methods.include?(method)
      return @proxy_all_methods || proxied_methods.include?(method.to_s)
    end

    def _is_ignored_method?(method)
      ::Putter.configuration.ignore_methods_from.each do |klass|
        return true if klass.methods.include?(method.to_sym)
        return true if klass.instance_methods.include?(method.to_sym)
      end
      return false
    end

    def _is_whitelisted_method?(method)
      ::Putter.configuration.methods_whitelist.map(&:to_sym).include?(method.to_sym)
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
