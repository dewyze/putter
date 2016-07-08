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

      methods_to_proxy(klass).each do |method|
        data = ProxyMethodData.new(method, "label")
        add_putter_method_to_proxy(proxy, :module_exec, data)
      end

      proxy
    end

    def self.methods_to_proxy(klass)
      ignored_methods = []

      Putter.configuration.ignore_methods_from.each do |klass|
        ignored_methods += klass.methods
      end

      klass.instance_methods - ignored_methods + Putter.configuration.methods_whitelist.map(&:to_sym)
    end
  end
end
