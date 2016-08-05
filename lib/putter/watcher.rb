module Putter
  module Watcher
    extend MethodCreator

    @label_registry = {}

    class WatcherData
      attr_accessor :label
    end

    def self.watch(obj, options={})
      data = WatcherData.new
      @label_registry[obj.singleton_class] = data

      _set_label(data, options[:label], obj.name)

      class << obj
        prepend InstanceFollower
        prepend Putter::Watcher.class_proxy(self)
      end
    end

    def self.label_for(klass)
      @label_registry[klass].label
    end

    def self.class_proxy(klass)
      proxy = MethodProxy.new

      methods_to_proxy(klass).each do |method|
        data = ProxyMethodData.new({ label: Putter::Watcher.label_for(klass), method: method })
        add_putter_method_to_proxy(proxy, :module_exec, data)
      end

      proxy
    end

    def self.methods_to_proxy(klass)
      ignored_methods = []

      Putter.configuration.ignore_methods_from.each do |klass|
        ignored_methods += klass.methods
      end

      klass.instance_methods - ignored_methods + Putter.configuration.methods_whitelist.map(&:to_sym) + [:new]
    end

    def self._set_label(data, label, class_name)
      if !label.nil? && label != ""
        data.label = label
      else
        data.label = class_name
      end
    end
  end
end
