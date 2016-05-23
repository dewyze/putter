module Putter
  module WatcherProxy
    def self.get_watcher(object)
      if object.class != Class && object.class != Module
        return InstanceWatcher
      end
    end
  end
end
