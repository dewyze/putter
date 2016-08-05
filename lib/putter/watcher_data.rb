module Putter
  class WatcherData
    attr_accessor :label, :methods

    def initialize(options, klass)
      _set_label(options[:label], klass)
    end

    def _set_label(label, klass)
      if !label.nil? && label != ""
        @label = label
      else
        @label = klass.name
      end
    end
  end
end
