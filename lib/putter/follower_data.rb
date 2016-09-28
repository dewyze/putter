module Putter
  class FollowerData
    attr_accessor :label

    def initialize(object, proxy, options)
      @proxy = proxy
      @proxied_methods = options[:methods] || []
      _set_label(options[:label], object)
    end

    def add_method?(method)
      return true if _is_whitelisted_method?(method)
      return false if _is_ignored_method?(method)
      return false if @proxy.instance_methods.include?(method)
      return true if @proxied_methods.empty?
      return true if @proxied_methods.include?(method)
    end

    def _set_label(label, object)
      if !label.nil?
        @label = label
      elsif object.class == Class
        @label = object.name
      else
        @label = object.class.name + " instance"
      end
    end

    def _is_whitelisted_method?(method)
      ::Putter.configuration.methods_whitelist.map(&:to_sym).include?(method.to_sym)
    end

    def _is_ignored_method?(method)
      ::Putter.configuration.ignore_methods_from.each do |klass|
        return true if klass.methods.include?(method.to_sym)
        return true if klass.instance_methods.include?(method.to_sym)
      end
      return false
    end
  end
end
