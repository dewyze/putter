module Putter
  class WatcherData
    attr_accessor :label, :proxy_methods

    def initialize(options, klass)
      @label = _set_label(options[:label], klass)
      @proxy_methods = _set_methods(options[:methods], klass.singleton_class)
    end

    def _set_label(label, klass)
      if !label.nil? && label != ""
        label
      else
        klass.name
      end
    end

    def _set_methods(methods, singleton_klass)
      if methods.nil?
        _methods_to_proxy(singleton_klass)
      elsif !methods.is_a?(Array)
        [methods]
      else
        methods
      end
    end

    def _methods_to_proxy(singleton_klass)
      ignored_methods = []

      Putter.configuration.ignore_methods_from.each do |klass|
        ignored_methods += klass.methods
      end

      singleton_klass.instance_methods - ignored_methods + Putter.configuration.methods_whitelist.map(&:to_sym) + [:new]
    end
  end
end
