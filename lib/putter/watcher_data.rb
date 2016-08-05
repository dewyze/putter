module Putter
  class WatcherData
    attr_accessor :label, :proxy_methods

    def initialize(options, klass)
      _set_label(options[:label], klass)
      _set_methods(options[:methods], klass)
    end

    def _set_label(label, klass)
      if !label.nil? && label != ""
        @label = label
      else
        @label = klass.name
      end
    end

    def _set_methods(methods, klass)
      if methods.nil?
        @proxy_methods = _methods_to_proxy(klass.singleton_class)
      elsif !methods.is_a?(Array)
        @proxy_methods = [methods]
      else
        @proxy_methods = methods
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
