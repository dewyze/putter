module Putter
  class WatcherData
    attr_accessor :label, :methods

    def initialize(options, klass)
      _set_label(options[:label], klass)
      _set_methods(options[:methods])
    end

    def _set_label(label, klass)
      if !label.nil? && label != ""
        @label = label
      else
        @label = klass.name
      end
    end

    def _set_methods(methods)
      if methods.nil?
        @methods = []
      elsif !methods.is_a?(Array)
        @methods = [methods]
      else
        @methods = methods
      end
    end
  end
end
