module Putter
  class Follower < BasicObject
    include MethodCreator

    attr_reader :object, :proxy

    def initialize(obj, options={})
      @object = obj
      @proxy = MethodProxy.new
      begin
        @object.singleton_class.send(:prepend, proxy)
      rescue ::NoMethodError
        ::Kernel.raise ::Putter::BasicObjectError
      end
      @data = FollowerData.new(@object, @proxy, options)
    end

    def method_missing(method, *args, &blk)
      if @data.add_method?(method)
        add_method(method)
      end

      if blk
        @object.send(method, *args, &blk)
      else
        @object.send(method, *args)
      end
    end

    def add_method(method)
      proxy_method_data = ProxyMethodData.new(label: @data.label, method: method)

      add_putter_instance_method_to_proxy(@proxy, proxy_method_data)
    end
  end
end
