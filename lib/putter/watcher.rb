module Putter
  class Watcher
    extend MethodCreator

    def self.watch(obj, options={})
      class << obj
        prepend InstanceFollower
        prepend Putter::Watcher.class_proxy(self)
      end
    end

    def self.class_proxy(klass)
      proxy = MethodProxy.new

      (klass.instance_methods - Object.methods).each do |method|
        data = ProxyMethodData.new(method, "label")
        add_putter_method_to_proxy(proxy, :module_exec, data)
      end

      proxy
    end
  end
end
